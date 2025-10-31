import request from '@/utils/request';

// 设备增加
export function equipmentCreate(data) {
  return request({ url: `/equipments/`, method: 'post', data })
}
// 设备列表
export function equipmentList(params) {
  return request({ url: `/equipments/`, method: 'get', params })
}

// 设备更新
export function equipmentUpdate(data) {
  return request({ url: `/equipments/${data.id}/`, method: 'put', data })
}

// 设备删除
export function equipmentDestroy(data) {
  return request({ url: `/equipments/${data.id}/`, method: 'delete', data })
}

// 设备详情
export function equipmentDetail(params) {
  return request({ url: `/equipments/${params.id}/`, method: 'get', params })
}
// 设备状态修改
export function equipmentStatusUpdate(data) {
  return request({ url: `/equipments/${data.id}/status/`, method: 'put', data })
}