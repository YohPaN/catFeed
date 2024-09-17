from django.contrib.auth.models import User
from rest_framework import serializers
from catFeed.models import Feed

class UserSerializer(serializers.Serializer):
    class Meta:
        model = User
        fields = ['username', 'email']

class FeedSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feed
        fields = ['type', 'created']


