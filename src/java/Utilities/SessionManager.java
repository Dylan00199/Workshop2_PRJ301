package Utilities;

import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.http.HttpSession;

/**
 * Registry of the single "live" session allowed per account.
 * Used to prevent the same account being logged in on two devices/browsers
 * at the same time.
 */
public class SessionManager {

    private static final SessionManager INSTANCE = new SessionManager();

    // account -> sessionId currently allowed to represent that account
    private final ConcurrentHashMap<String, String> accountToSessionId = new ConcurrentHashMap<>();
    // sessionId -> account (reverse lookup, used by the listener on session destroy)
    private final ConcurrentHashMap<String, String> sessionIdToAccount = new ConcurrentHashMap<>();
    // sessionId -> the actual HttpSession object, so we can invalidate the old one
    private final ConcurrentHashMap<String, HttpSession> liveSessions = new ConcurrentHashMap<>();

    private SessionManager() {
    }

    public static SessionManager getInstance() {
        return INSTANCE;
    }

    /**
     * Registers a new login for the given account, invalidating any previous
     * session that account was using elsewhere.
     */
    public synchronized void registerLogin(String account, HttpSession newSession) {
        String oldSessionId = accountToSessionId.get(account);
        if (oldSessionId != null && !oldSessionId.equals(newSession.getId())) {
            HttpSession oldSession = liveSessions.get(oldSessionId);
            if (oldSession != null) {
                try {
                    // Mark it so the login page can show a friendly message if that
                    // browser tab makes another request.
                    oldSession.setAttribute("KICKED_OUT", true);
                    oldSession.invalidate();
                } catch (IllegalStateException ignored) {
                    // already invalidated
                }
            }
            liveSessions.remove(oldSessionId);
            sessionIdToAccount.remove(oldSessionId);
        }

        accountToSessionId.put(account, newSession.getId());
        sessionIdToAccount.put(newSession.getId(), account);
        liveSessions.put(newSession.getId(), newSession);
    }

    /** Called by the listener when ANY session is destroyed (timeout or invalidate). */
    public synchronized void onSessionDestroyed(String sessionId) {
        String account = sessionIdToAccount.remove(sessionId);
        liveSessions.remove(sessionId);
        if (account != null) {
            // Only clear the account mapping if it still points at this exact
            // session (avoids clobbering a newer login that just replaced it).
            accountToSessionId.remove(account, sessionId);
        }
    }

    public boolean isAccountLoggedInElsewhere(String account, String currentSessionId) {
        String activeId = accountToSessionId.get(account);
        return activeId != null && !activeId.equals(currentSessionId);
    }
}
