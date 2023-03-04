from django.shortcuts import render

from map.models import Degradation, Hospital, Population, Road


def index(request, current_nr='RNP 2'):
    return render(request, 'index.html', {
        'rn2': Road().get_nr_geojson('RNP 2'),
        'rn4': Road().get_nr_geojson('RNP 4'),
        'rn7': Road().get_nr_geojson('RNP 7'),
        'hospitals': Hospital().get_hp_geojson(),
        'degradations': Degradation().get_all_geojson(),
        'populations': Population().get_all_geojson(),
        'selected_nr': Degradation().get_dgdt_by_roadno(current_nr)
    }
    )


def road(request):
    if request.method == 'POST':
        nr = request.POST.get('nr')
    return index(request, nr)


def suggestion(request):
    degs = Degradation().get_all()
    degradations = []
    i = 0
    while i < len(degs):
        degradation = {
            'id': degs[i]['id'],
            'nr': degs[i]['roadno'],
            'start': degs[i]['start_desc'],
            'end': degs[i]['end_desc'],
            'population': Degradation().population_count(degs[i]['id'], request.POST.get('radius'))['populations'],
            'hospital': Degradation().hospital_count(degs[i]['id'], request.POST.get('radius'))['hospital']
        }
        degradations.append(degradation)
        i = i + 1
    degradations.sort(key=lambda x: (
        x['population'], x['hospital']), reverse=True)
    return render(request, 'suggestion.html', {'suggestion': degradations})
