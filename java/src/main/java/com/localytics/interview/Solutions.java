package com.localytics.interview;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.io.IOException;

public class Solutions {
  public static void solve() throws IOException {
    System.out.println("Solve it here.");
  }
}


class JsonParser {
  public static Map<String, User> getUsers() throws IOException {
    byte[] jsonData = Files.readAllBytes(Paths.get("../data/users.json"));
    UserJson userJson = new UserJson();
    ObjectMapper objectMapper = new ObjectMapper();

    userJson = objectMapper.readValue(jsonData, UserJson.class);
    return userJson.users;
  }

  public static List<Event> getEvents() throws IOException {
    byte[] jsonData = Files.readAllBytes(Paths.get("../data/events.json"));
    EventJson eventJson = new EventJson();
    ObjectMapper objectMapper = new ObjectMapper();

    eventJson = objectMapper.readValue(jsonData, EventJson.class);
    return eventJson.events;
  }
}

class EventJson {
  public List<Event> events;
}

class Event {
  private String name;
  private int timestamp;
  private String user_id;

  public String getName() { return name; }
  public void setName(String name) { this.name = name; }

  public int getTimestamp() { return timestamp; }
  public void setTimestamp(int timestamp) { this.timestamp = timestamp; }

  public String getUser_id() { return user_id; }
  public void setUser_id(String user_id) { this.user_id = user_id; }
}

class UserJson {
  public Map<String,User> users;
}

class User {
  private String gender;
  private int age;
  private String device;

  public String getGender() { return gender; }
  public void setGender(String gender) { this.gender = gender; }

  public int getAge() { return age; }
  public void setAge(int age) { this.age = age; }

  public String getDevice() { return device; }
  public void setDevice(String device) { this.device = device; }
}
