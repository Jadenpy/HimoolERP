<template>
  <div class="equipment-list-container">
    <!-- 页面标题 -->
    <el-page-header 
      @back="handleBack" 
      content="设备信息管理"
    ></el-page-header>

    <!-- 操作区 -->
    <el-row :gutter="20" class="operate-bar">
      <el-col :span="8">
        <el-input
          v-model="searchKeyword"
          placeholder="请输入设备名称/供应商搜索"
          prefix-icon="el-icon-search"
          clearable
          @keyup.enter.native="getEquipmentList"
        ></el-input>
      </el-col>
      <el-col :span="2" :offset="14">
        <el-button 
          type="primary" 
          icon="el-icon-plus" 
          @click="handleAdd"
        >
          新增设备
        </el-button>
      </el-col>
    </el-row>

    <!-- 设备列表 -->
    <el-table
      :data="equipmentList"
      border
      stripe
      style="width: 100%; margin-top: 15px"
    >
      <el-table-column 
        type="index" 
        label="序号" 
        width="80" 
        align="center"
      ></el-table-column>
      <el-table-column 
        prop="name" 
        label="设备名称" 
        align="center"
      ></el-table-column>
      <el-table-column 
        prop="location" 
        label="安装位置" 
        align="center"
      ></el-table-column>
      <el-table-column 
        prop="supplier" 
        label="供应商" 
        align="center"
      ></el-table-column>
      <el-table-column 
        prop="model" 
        label="设备型号" 
        align="center"
      ></el-table-column>
      <el-table-column 
        prop="status" 
        label="设备状态" 
        align="center"
      >
        <template slot-scope="scope">
          <el-tag 
            :type="scope.row.status === '正常' ? 'success' : 'danger'"
          >
            {{ scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column 
        label="操作" 
        width="200" 
        align="center"
      >
        <template slot-scope="scope">
          <el-button 
            size="mini" 
            type="text" 
            @click="handleEdit(scope.row)"
          >
            编辑
          </el-button>
          <el-button 
            size="mini" 
            type="text" 
            style="color: #F56C6C" 
            @click="handleDelete(scope.row.id)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="pagination.currentPage"
      :page-sizes="[10, 20, 50]"
      :page-size="pagination.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="pagination.total"
      style="margin-top: 15px; text-align: right"
    ></el-pagination>

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="equipmentForm"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="设备名称" prop="name">
          <el-input 
            v-model="formData.name" 
            placeholder="请输入设备名称"
          ></el-input>
        </el-form-item>
        <el-form-item label="安装位置" prop="location">
          <el-input 
            v-model="formData.location" 
            placeholder="请输入安装位置"
          ></el-input>
        </el-form-item>
        <el-form-item label="供应商" prop="supplier">
          <el-input 
            v-model="formData.supplier" 
            placeholder="请输入供应商"
          ></el-input>
        </el-form-item>
        <el-form-item label="设备型号" prop="model">
          <el-input 
            v-model="formData.model" 
            placeholder="请输入设备型号"
          ></el-input>
        </el-form-item>
        <el-form-item label="设备状态" prop="status">
          <el-select 
            v-model="formData.status" 
            placeholder="请选择设备状态"
          >
            <el-option label="正常" value="正常"></el-option>
            <el-option label="故障" value="故障"></el-option>
            <el-option label="维护中" value="维护中"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button 
          type="primary" 
          @click="dialogTitle === '新增设备' ? handleSubmit() : handleUpdate()"
        >
          确认
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios' // 假设项目已引入axios

export default {
  name: 'EquipmentList',
  data() {
    return {
      // 搜索关键词
      searchKeyword: '',
      // 设备列表数据
      equipmentList: [],
      // 分页参数
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      // 弹窗状态
      dialogVisible: false,
      dialogTitle: '',
      // 表单数据
      formData: {
        id: '',
        name: '',
        location: '',
        supplier: '',
        model: '',
        status: ''
      },
      // 表单验证规则
      formRules: {
        name: [
          { required: true, message: '请输入设备名称', trigger: 'blur' },
          { max: 50, message: '名称不能超过50个字符', trigger: 'blur' }
        ],
        location: [
          { required: true, message: '请输入安装位置', trigger: 'blur' }
        ],
        supplier: [
          { required: true, message: '请输入供应商', trigger: 'blur' }
        ],
        status: [
          { required: true, message: '请选择设备状态', trigger: 'change' }
        ]
      }
    }
  },
  created() {
    // 页面加载时获取设备列表
    this.getEquipmentList()
  },
  methods: {
    // 返回上一页
    handleBack() {
      this.$router.go(-1)
    },
    // 获取设备列表
    async getEquipmentList() {
      try {
        const params = {
          page: this.pagination.currentPage,
          size: this.pagination.pageSize,
          keyword: this.searchKeyword
        }
        const res = await axios.get('/api/equipment/list', { params })
        // 假设接口返回格式：{ code: 200, data: { list: [], total: 0 } }
        if (res.data.code === 200) {
          this.equipmentList = res.data.data.list
          this.pagination.total = res.data.data.total
        } else {
          this.$message.error('获取设备列表失败：' + res.data.msg)
        }
      } catch (error) {
        this.$message.error('网络错误，无法获取设备列表')
        console.error(error)
      }
    },
    // 分页尺寸变化
    handleSizeChange(size) {
      this.pagination.pageSize = size
      this.getEquipmentList()
    },
    // 页码变化
    handleCurrentChange(page) {
      this.pagination.currentPage = page
      this.getEquipmentList()
    },
    // 新增设备
    handleAdd() {
      this.dialogTitle = '新增设备'
      this.dialogVisible = true
      // 重置表单
      this.$nextTick(() => {
        this.$refs.equipmentForm.resetFields()
        this.formData.id = ''
      })
    },
    // 编辑设备
    handleEdit(row) {
      this.dialogTitle = '编辑设备'
      this.dialogVisible = true
      // 复制行数据到表单
      this.formData = { ...row }
    },
    // 删除设备
    handleDelete(id) {
      this.$confirm('确定要删除该设备吗？删除后不可恢复', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await axios.delete(`/api/equipment/${id}`)
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.getEquipmentList() // 重新获取列表
          } else {
            this.$message.error('删除失败：' + res.data.msg)
          }
        } catch (error) {
          this.$message.error('删除失败，网络错误')
          console.error(error)
        }
      }).catch(() => {
        this.$message.info('已取消删除')
      })
    },
    // 提交新增
    async handleSubmit() {
      this.$refs.equipmentForm.validate(async (valid) => {
        if (valid) {
          try {
            const res = await axios.post('/api/equipment', this.formData)
            if (res.data.code === 200) {
              this.$message.success('新增成功')
              this.dialogVisible = false
              this.getEquipmentList() // 重新获取列表
            } else {
              this.$message.error('新增失败：' + res.data.msg)
            }
          } catch (error) {
            this.$message.error('新增失败，网络错误')
            console.error(error)
          }
        }
      })
    },
    // 提交更新
    async handleUpdate() {
      this.$refs.equipmentForm.validate(async (valid) => {
        if (valid) {
          try {
            const res = await axios.put(`/api/equipment/${this.formData.id}`, this.formData)
            if (res.data.code === 200) {
              this.$message.success('更新成功')
              this.dialogVisible = false
              this.getEquipmentList() // 重新获取列表
            } else {
              this.$message.error('更新失败：' + res.data.msg)
            }
          } catch (error) {
            this.$message.error('更新失败，网络错误')
            console.error(error)
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.equipment-list-container {
  padding: 20px;
  background-color: #fff;
  min-height: calc(100vh - 60px);
}

.operate-bar {
  margin-top: 20px;
}
</style>