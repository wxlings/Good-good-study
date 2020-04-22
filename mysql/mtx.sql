/*
Navicat MySQL Data Transfer

Source Server         : 本机MySQL
Source Server Version : 50727
Source Host           : localhost:3306
Source Database       : mtx

Target Server Type    : MYSQL
Target Server Version : 50727
File Encoding         : 65001

Date: 2020-04-12 19:54:35
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `morder`
-- ----------------------------
DROP TABLE IF EXISTS `morder`;
CREATE TABLE `morder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `order_price` int(11) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `recv_phone` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10017 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of morder
-- ----------------------------
INSERT INTO `morder` VALUES ('10000', '3', '12', '北京', '1', '2019-10-09 17:22:05', '13500000000');
INSERT INTO `morder` VALUES ('10001', '6', '3567', '上海', '0', '2019-10-09 17:22:06', '13500000000');
INSERT INTO `morder` VALUES ('10002', '5', '54', '广州', '1', '2019-10-09 17:22:31', '13500000010');
INSERT INTO `morder` VALUES ('10003', '7', '854', '深圳', '0', '2019-10-09 17:22:07', '13500000000');
INSERT INTO `morder` VALUES ('10004', '4', '257', '深圳', '1', '2019-10-09 17:22:28', '13500000009');
INSERT INTO `morder` VALUES ('10005', '6', '76', '广州', '0', '2019-10-09 17:22:57', '13500000008');
INSERT INTO `morder` VALUES ('10006', '8', '853', '北京', '0', '2019-10-09 17:22:10', '13500000000');
INSERT INTO `morder` VALUES ('10007', '8', '98', '上海', '1', '2019-10-09 17:22:54', '13500000006');
INSERT INTO `morder` VALUES ('10009', '10', '533', '广州', '1', '2019-10-09 17:22:26', '13500000002');
INSERT INTO `morder` VALUES ('10010', '5', '123', '上海', '0', '2019-10-09 17:22:12', '13500000000');
INSERT INTO `morder` VALUES ('10011', '3', '11', '上海', '0', '2019-10-09 18:04:18', '13500000000');
INSERT INTO `morder` VALUES ('10012', '7', '865', '深圳', '1', '2019-10-09 17:22:35', '13500000111');
INSERT INTO `morder` VALUES ('10013', '5', '43', '上海', '0', '2019-10-09 17:22:14', '13500000000');
INSERT INTO `morder` VALUES ('10014', '6', '8765', '北京', '1', '2019-10-09 17:22:38', '13500000222');
INSERT INTO `morder` VALUES ('10015', '2', '45', '上海', '1', '2019-10-09 17:22:41', '13500000333');
INSERT INTO `morder` VALUES ('10016', '13', '9876', '上海', '1', '2019-10-24 16:11:40', '13500000444');

-- ----------------------------
-- Table structure for `score`
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` char(150) DEFAULT NULL,
  `lesson` varchar(11) DEFAULT NULL,
  `score` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES ('1', '张三', '语文', '88.5');
INSERT INTO `score` VALUES ('2', '李四', '语文', '96');
INSERT INTO `score` VALUES ('3', '王五', '语文', '80');
INSERT INTO `score` VALUES ('4', '麻子', '语文', '77');
INSERT INTO `score` VALUES ('5', '王柳', '语文', '91');
INSERT INTO `score` VALUES ('6', '哈哈', '语文', '92');
INSERT INTO `score` VALUES ('7', '李丽', '语文', '86');
INSERT INTO `score` VALUES ('8', '王木', '语文', '68');
INSERT INTO `score` VALUES ('9', '张三', '数学', '90');
INSERT INTO `score` VALUES ('10', '李四', '数学', '67');
INSERT INTO `score` VALUES ('11', '王五', '数学', '58.5');
INSERT INTO `score` VALUES ('12', '麻子', '数学', '88');
INSERT INTO `score` VALUES ('13', '王柳', '数学', '77');
INSERT INTO `score` VALUES ('14', '哈哈', '数学', '96');
INSERT INTO `score` VALUES ('15', '李丽', '数学', '82');
INSERT INTO `score` VALUES ('16', '王木', '数学', '93');
INSERT INTO `score` VALUES ('17', '张三', '英语', '89');
INSERT INTO `score` VALUES ('18', '李四', '英语', '67');
INSERT INTO `score` VALUES ('19', '王五', '英语', '87');
INSERT INTO `score` VALUES ('20', '麻子', '英语', '78');
INSERT INTO `score` VALUES ('21', '王柳', '英语', '64');
INSERT INTO `score` VALUES ('22', '哈哈', '英语', '91');
INSERT INTO `score` VALUES ('23', '李丽', '英语', '68');
INSERT INTO `score` VALUES ('24', '王木', '英语', '82');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` int(2) DEFAULT NULL COMMENT '男：1，女：0',
  `phone_num` varchar(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22936 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '北河', '111111', '95', '0', '13500000000', 'mtx_0@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('2', '沙陌', '111111', '96', '1', '13500000001', 'mtx_1@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('3', '楼老师', '111111', '95', '0', '13500000002', 'mtx_2@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('4', '安老师', '111111', '87', '1', '13500000003', 'mtx_3@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('5', '沉醉', '111111', '51', '0', '13500000004', 'mtx_4@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('6', '苗苗', '111111', '95', '1', '13500000005', 'mtx_5@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('7', '婷婷', '111111', '23', '0', '13500000006', 'mtx_6@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('8', '周老师', '111111', '32', '1', '13500000007', 'mtx_3@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('9', '琪琪', '111111', '91', '0', '13500000008', 'mtx_8@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('10', '马老师', '111111', '59', '1', '13500000009', 'mtx_9@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('11', '极光', '111111', '23', '0', '13500000010', 'mtx_10@qq.com', '2019-09-17 17:46:49');
INSERT INTO `user` VALUES ('12', '王老师', '111111', '0', '1', '13500000011', 'mtx_1@qq.com', '2019-09-17 17:46:49');
