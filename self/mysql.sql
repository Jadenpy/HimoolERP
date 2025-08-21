-- 删除旧数据库（如果存在）
DROP DATABASE IF EXISTS erp_db;

-- 创建新数据库，指定 utf8mb4 字符集和排序规则
CREATE DATABASE erp_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

-- 使用新建的数据库
USE erp_db;

-- 如果需要新用户，先删除旧用户（8.0 语法）
DROP USER IF EXISTS 'erp_user'@'%';

-- 创建用户（修改 'StrongPassword123!' 为你自己的安全密码）
CREATE USER 'erp_user'@'%' IDENTIFIED WITH mysql_native_password BY '@Kautex99';

-- 给用户授权
GRANT ALL PRIVILEGES ON erp_db.* TO 'erp_user'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

-- 确认当前数据库字符集（8.0 新排序规则）
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'erp_db';
