from extensions.common.base import *
from extensions.serializers import *
from extensions.exceptions import *

from rest_framework import serializers
from .models import Equipment

class EquipmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Equipment
        fields = "__all__"


# __all__ = [

# ]
