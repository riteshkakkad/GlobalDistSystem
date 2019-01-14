<%@ Application Language="C#" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="NHibernate" %>
<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>
<%@ Import Namespace="Helper" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net.Mime" %>
<%@ Import Namespace="System.ComponentModel" %>

<script RunAt="server">

    void Application_PreRequestHandlerExecute(object sender, EventArgs e)
    {
        if (Context.Session != null)
        {
           /* HttpApplication app = sender as HttpApplication;
            string acceptEncoding = app.Request.Headers["Accept-Encoding"];
            Stream prevUncompressedStream = app.Response.Filter;
            String url = app.Request.Url.OriginalString;
            HttpCookie cookie = Request.Cookies.Get("airnetz-country-setup");

            if (Session["Country"] == null)
            {
                if (cookie != null)
                {
                    Session.Add("Country", cookie.Value);
                }
                else
                {
                    Session.Add("Country", "US");
                }
            }
            else
            {
                if (cookie != null)
                {
                    Session["Country"] = cookie.Value;
                }
                else
                {
                    Session["Country"] = "US";
                }
            }

            if (url.EndsWith(".jpeg") || url.EndsWith(".jpg") || url.EndsWith(".gif") || url.EndsWith(".png"))
                return;

            if (app.Request["HTTP_X_MICROSOFTAJAX"] != null)
                return;

            if (acceptEncoding == null || acceptEncoding.Length == 0)
                return;

            acceptEncoding = acceptEncoding.ToLower();

            if (acceptEncoding.Contains("deflate") || acceptEncoding == "*")
            {
                // defalte
                app.Response.Filter = new DeflateStream(prevUncompressedStream,
                    CompressionMode.Compress);
                app.Response.AppendHeader("Content-Encoding", "deflate");
            }
            else if (acceptEncoding.Contains("gzip"))
            {
                // gzip
                app.Response.Filter = new GZipStream(prevUncompressedStream,
                    CompressionMode.Compress);
                app.Response.AppendHeader("Content-Encoding", "gzip");
            }*/
        }
    }

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        /*if (Server.GetLastError() != null)
        {
            Exception ex = Server.GetLastError().GetBaseException();
            Email email;
            MailAddress m;

            email = new Email();
            email.MailServerName = "mail.airnetzcharter.com";

            email.MailServerUserName = "admin@airnetzcharter.com";
            email.MailServerPassword = "admin7895";
            email.Subject = "airnetz charter error";
            m = new MailAddress("admin@airnetzcharter.com", "Airnetz Charter");
            email.From = m;
            email.Tos.Add("nikhil.khekade@gmail.com");

            email.sendEmail(ex.TargetSite + "<br>" + ex.ToString() + "<br>" + ex.StackTrace);
        }*/



    }

    void Session_Start(object sender, EventArgs e)
    {

        if (!Context.Request.PhysicalPath.Contains("\\Admin\\"))
        {

           /* HttpCookie cookie = Request.Cookies.Get("airnetz-country-setup");
            if (cookie != null)
            {
                String checkurl = AdminBO.GetRedirectionUrlWithParams(Request.Url, cookie.Value);
                Uri checkuri = new Uri(checkurl);
                if (!Request.Url.Host.Equals(checkuri.Host))
                {
                    Response.Redirect(checkurl);
                }

                try
                {
                    Country c = AdminDAO.GetCountryByID(cookie.Value);
                    Session.Add("Country", c.CountryID);
                }
                catch (Exception ex)
                {
                    Session.Add("Country", "US");
                }


            }
            else
            {
                String country = AdminBO.GetCountryToRedirect(Request.ServerVariables.Get("REMOTE_ADDR"));
                Session.Add("Country", country);
                HttpCookie newcookie = new HttpCookie("airnetz-country-setup", country);
                newcookie.Domain = ".airnetzcharter.com";
                newcookie.Expires = DateTime.Now.AddDays(2);
                Response.Cookies.Add(newcookie);
                Response.Redirect(AdminBO.GetRedirectionUrlWithParams(Context.Request.Url, country));

            }*/
            Session.Add("Country", "US");
        }
        else
        {
            Session.Add("Country", "US");

        }

    }


    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
    void Application_BeginRequest(object sender, EventArgs e)
    {
        /* Fix for the Flash Player Cookie bug in Non-IE browsers.
         * Since Flash Player always sends the IE cookies even in FireFox
         * we have to bypass the cookies by sending the values as part of the POST or GET
         * and overwrite the cookies with the passed in values.
         * 
         * The theory is that at this point (BeginRequest) the cookies have not been read by
         * the Session and Authentication logic and if we update the cookies here we'll get our
         * Session and Authentication restored correctly
         */

        try
        {
            string session_param_name = "ASPSESSID";
            string session_cookie_name = "ASP.NET_SESSIONID";

            if (HttpContext.Current.Request.Form[session_param_name] != null)
            {
                UpdateCookie(session_cookie_name, HttpContext.Current.Request.Form[session_param_name]);
            }
            else if (HttpContext.Current.Request.QueryString[session_param_name] != null)
            {
                UpdateCookie(session_cookie_name, HttpContext.Current.Request.QueryString[session_param_name]);
            }
        }
        catch (Exception)
        {
            Response.StatusCode = 500;
            Response.Write("Error Initializing Session");
        }

        try
        {
            string auth_param_name = "AUTHID";
            string auth_cookie_name = FormsAuthentication.FormsCookieName;

            if (HttpContext.Current.Request.Form[auth_param_name] != null)
            {
                UpdateCookie(auth_cookie_name, HttpContext.Current.Request.Form[auth_param_name]);
            }
            else if (HttpContext.Current.Request.QueryString[auth_param_name] != null)
            {
                UpdateCookie(auth_cookie_name, HttpContext.Current.Request.QueryString[auth_param_name]);
            }

        }
        catch (Exception)
        {
            Response.StatusCode = 500;
            Response.Write("Error Initializing Forms Authentication");
        }
    }
    void UpdateCookie(string cookie_name, string cookie_value)
    {
        HttpCookie cookie = HttpContext.Current.Request.Cookies.Get(cookie_name);
        if (cookie == null)
        {
            cookie = new HttpCookie(cookie_name);
            HttpContext.Current.Request.Cookies.Add(cookie);
        }
        cookie.Value = cookie_value;
        HttpContext.Current.Request.Cookies.Set(cookie);
    }
    protected void Application_AuthenticateRequest(object sender, EventArgs e)
    {
        if (HttpContext.Current.User != null)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                if (HttpContext.Current.User.Identity is FormsIdentity)
                {
                    FormsIdentity id =
                        (FormsIdentity)HttpContext.Current.User.Identity;
                    FormsAuthenticationTicket ticket = id.Ticket;
                    string userData = ticket.UserData;
                    string[] roles = userData.Split(',');
                    HttpContext.Current.User = new GenericPrincipal(id, roles);
                }
            }
        }
    }
</script>

