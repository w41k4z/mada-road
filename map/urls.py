from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('road/', views.road, name='road'),
    path('suggestion/', views.suggestion, name="suggestion")
]
