package com.feihu.llm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 在线大模型学习平台 - 主启动类
 * 
 * @author feihu1991
 * @version 1.0
 * @since 2026-03-01
 */
@SpringBootApplication
@EnableTransactionManagement
public class LLMLearningPlatformApplication {

    public static void main(String[] args) {
        SpringApplication.run(LLMLearningPlatformApplication.class, args);
        System.out.println("========================================");
        System.out.println("在线大模型学习平台启动成功！");
        System.out.println("API文档地址: http://localhost:8080/swagger-ui.html");
        System.out.println("========================================");
    }
}
