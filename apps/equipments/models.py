from django.db import models


class Equipment(models.Model):
    name = models.CharField(max_length=100, verbose_name="设备名称")
    model = models.CharField(max_length=50, verbose_name="设备型号")
    vendor = models.CharField(max_length=100, verbose_name="厂商")
    purchase_time = models.DateField(verbose_name="购入时间")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="原值")
    location = models.CharField(max_length=100, verbose_name="位置")
    status = models.CharField(
        max_length=20, 
        choices=[("online", "在线"), ("offline", "离线"), ("fault", "故障")],
        default="online",
        verbose_name="设备状态"
    )
    create_time = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")
    update_time = models.DateTimeField(auto_now=True, verbose_name="更新时间")

    class Meta:
        verbose_name = "设备"
        verbose_name_plural = "设备管理"

    def __str__(self):
        return self.name