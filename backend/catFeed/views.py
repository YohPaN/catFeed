from django.contrib.auth.models import User
from rest_framework import permissions, viewsets
from catFeed.models import Feed
from datetime import datetime
from catFeed.serializers import UserSerializer, FeedSerializer
from rest_framework.response import Response
from django.core.exceptions import ObjectDoesNotExist

class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


class FeedViewSet(viewsets.ModelViewSet):
    queryset = Feed.objects.all()
    serializer_class = FeedSerializer

    def list(self, request):
        try:
            croquetteFeed = Feed.objects.filter(type='croquette').latest('created')
        except ObjectDoesNotExist:
            croquetteFeed = None

        try:
            tunaFeed = Feed.objects.filter(type='tuna').latest('created')
        except ObjectDoesNotExist:
            tunaFeed = None        
        
        serializerCroquette = FeedSerializer(croquetteFeed) 
        serializerTuna = FeedSerializer(tunaFeed) 

        return Response(data={'croquetteFeed': serializerCroquette.data, 'tunaFeed': serializerTuna.data})

    def create(self, request):
        now = datetime.now()
        feedType = request.data.get('feedType')
        dt_string = now.strftime("%Y-%m-%d %H:%M:%S")

        Feed.objects.create(type=feedType, user_id=1, created=dt_string)

        return Response(status=202)

