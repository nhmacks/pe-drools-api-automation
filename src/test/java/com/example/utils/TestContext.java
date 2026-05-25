package com.example.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * TestContext simple basado en ThreadLocal para compartir datos entre step defs
 * sin introducir estado global inseguro en ejecución paralela.
 */
public final class TestContext {

    private static final ThreadLocal<Map<String, String>> CONTEXT = ThreadLocal.withInitial(HashMap::new);

    private TestContext() {}

    public static void set(String key, String value) {
        CONTEXT.get().put(key, value);
    }

    public static String get(String key) {
        return CONTEXT.get().get(key);
    }

    public static void clear() {
        CONTEXT.get().clear();
    }

    // Convenience helpers
    public static void setEmail(String email) { set("email", email); }
    public static String getEmail() { return get("email"); }

    public static void setPassword(String password) { set("password", password); }
    public static String getPassword() { return get("password"); }

    public static void setPhone(String phone) { set("phone", phone); }
    public static String getPhone() { return get("phone"); }
}

