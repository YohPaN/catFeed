from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Feed(models.Model):
    type = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, default=1)
    created = models.DateTimeField()

