package Listener;

import Utilities.SessionManager;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class SessionTrackingListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Nothing to do here - registration happens explicitly in loginController
        // once we KNOW who the account is (session creation alone doesn't tell us that).
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        SessionManager.getInstance().onSessionDestroyed(se.getSession().getId());
    }
}
