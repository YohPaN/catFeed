from django.contrib import admin
from django.urls import include, path
from rest_framework import routers

from catFeed import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'Feed', views.FeedViewSet)

urlpatterns = [
    path('', include(router.urls)),
]