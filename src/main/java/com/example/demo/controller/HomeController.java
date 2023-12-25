package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping("")
    public String hello() {
        return "Hello!";
    }

    @GetMapping("/version")
    public String version() {
        return "version=v0.1";
    }
}
