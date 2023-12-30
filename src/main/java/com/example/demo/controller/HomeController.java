package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
    final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @GetMapping("")
    public String hello() {
        logger.info("/");
        return "Hello!";
    }

    @GetMapping("/version")
    public String version() {
        logger.info("/version");
        return "version=v0.1";
    }
}
