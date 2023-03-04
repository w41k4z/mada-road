import json
from django.db import connections, models


class Road(models.Model):
    class Meta:
        managed = False
        db_table = 'madagascar_roads'

    def __str__(self):
        return self.name

    def get_nr_geojson(self, road):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT ST_AsGeoJSON(geom) FROM madagascar_roads WHERE roadno = '" + road + "'")
            rows = cursor.fetchall()
        geojson = [json.loads(row[0]) for row in rows]
        return geojson


class Hospital(models.Model):
    class Meta:
        managed = False
        db_table = 'hospital'

    def __str__(self):
        return self.name

    def get_hp_geojson(self):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT ST_AsGeoJSON(coordinate) FROM hospital")
            rows = cursor.fetchall()
        geojson = [json.loads(row[0]) for row in rows]
        return geojson


class Degradation(models.Model):
    class Meta:
        managed = False
        db_table = 'degradation'

    def __str__(self):
        return ""

    def get_all(self):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT degradation.*, surface_type.unit_price, surface_type.duration FROM degradation JOIN surface_type ON surface_type.name = degradation.surftype")
            rows = cursor.fetchall()
        degradations = []
        for row in rows:
            degradation = {
                'id': row[0],
                'roadno': row[1],
                'surftype': row[2],
                'starts': row[3],  # km
                'ends': row[4],  # km
                'start_desc': row[5],
                'end_desc': row[6],
                'length': row[7] * 1000,  # km
                'width': row[8],  # m
                'level': row[9],
                'unit_price': row[10],
                'duration': row[11],
                'total_reparation': (float(row[9]) / 100) * float(row[8]) * (float(row[7]) * 1000) * float(row[10]),
                'total_duration': (float(row[9]) / 100) * float(row[8]) * (float(row[7]) * 1000) * float(row[10]) * float(row[11])
            }
            degradations.append(degradation)
        return degradations

    def get_dgdt_by_roadno(self, roadno):
        degradations = self.get_all()
        result = []
        for degradation in degradations:
            if degradation['roadno'] == roadno:
                result.append(degradation)
        return result

    def get_all_geojson(self):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT ST_AsGeoJSON(location) FROM degradation_detail")
            rows = cursor.fetchall()
        geojson = [json.loads(row[0]) for row in rows]
        return geojson

    def hospital_count(self, degradation_id, radius):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"Select degradation.start_desc, degradation.end_desc, hospital.name, deg.kilometer_point, ST_Distance(deg.location:: geography, (coordinate:: geography)) distance From hospital JOIN degradation_detail deg ON ST_DWithin(deg.location:: geography, hospital.coordinate:: geography," + str(radius) + ") JOIN degradation ON degradation.id = deg.degradation_id WHERE deg.degradation_id = " + str(degradation_id) + " ORDER BY kilometer_point")
            rows = cursor.fetchall()
        hospital_count = set()
        if (len(rows) < 1):
            return {
                'degradation_id': degradation_id,
                'from': '',
                'to': '',
                'hospitals': 0,
                'hospital': len(hospital_count)
            }
        for row in rows:
            starts = row[0]
            ends = row[1]
            hospital_count.add(row[2])
        degradation = {
            'degradation_id': degradation_id,
            'from': starts,
            'to': ends,
            'hospitals': hospital_count,
            'hospital': len(hospital_count)
        }
        return degradation  # [degradation]

    def population_count(self, degradation_id, radius):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"Select degradation.start_desc, degradation.end_desc, population.id, population.nbr, ST_Distance(deg.location::geography, (population.location::geography)) distance From population JOIN degradation_detail deg ON ST_DWithin(deg.location:: geography, population.location::geography," + str(radius) + ") JOIN degradation ON degradation.id = deg.degradation_id WHERE deg.degradation_id = " + str(degradation_id) + " ORDER BY kilometer_point")
            rows = cursor.fetchall()
        population_count = set()
        if (len(rows) < 1):
            return {
                'degradation_id': degradation_id,
                'from': '',
                'to': '',
                'populations': 0,
                'population': population_count
            }
        for row in rows:
            starts = row[0]
            ends = row[1]
            population_count.add(row[2])
        sum = 0
        for pop in population_count:
            sum = sum + Population().get_population_nbr(pop)[0]
        degradation = {
            'degradation_id': degradation_id,
            'from': starts,
            'to': ends,
            'populations': sum,
            'population': population_count
        }
        return degradation


class Population(models.Model):
    class Meta:
        managed = False
        db_table = 'population'

    def __str__(self):
        return ""

    def get_all_geojson(self):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT ST_AsGeoJSON(location) FROM population")
            rows = cursor.fetchall()
        geojson = [json.loads(row[0]) for row in rows]
        return geojson

    def get_population_nbr(self, population_id):
        with connections['default'].cursor() as cursor:
            cursor.execute(
                f"SELECT nbr FROM population WHERE id = " + str(population_id))
            rows = cursor.fetchall()
        people = rows[0]
        return people
