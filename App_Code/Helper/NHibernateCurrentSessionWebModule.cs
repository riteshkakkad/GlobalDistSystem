using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NHibernate.Context;
using NHibernate;
using NHibernate.Cfg;

using System.Collections.Generic;
using System.Reflection;
using Entities;
using Iesi.Collections;
using DataAccessLayer;

public class NHibernateCurrentSessionWebModule : IHttpModule
{
    public void Init(HttpApplication context)
    {
        context.BeginRequest += new EventHandler(Application_BeginRequest);
        context.EndRequest += new EventHandler(Application_EndRequest);
        
    }
    public void Dispose()
    {
    }
    private void Application_BeginRequest(object sender, EventArgs e)
    {
        ISession session = NHibernateHelper.OpenSession();
        session.BeginTransaction();
        CurrentSessionContext.Bind(session);
        session.EnableFilter("allaircrafts").SetParameter("Status",(short)2);
        session.EnableFilter("alloperators").SetParameter("Status", 2);
        session.EnableFilter("allbids").SetParameter("Status",(short) 2);
        session.EnableFilter("allrequests").SetParameter("Status", (short)2);
        session.EnableFilter("allagents").SetParameter("Status", 2);
        session.EnableFilter("allcustomers").SetParameter("Status", 2);
        session.EnableFilter("alloperatorrequests").SetParameter("Status", (short)2);
        session.EnableFilter("allemptylegs").SetParameter("Status", 2);
        session.EnableFilter("allemptylegoffers").SetParameter("Status", 2);
        session.EnableFilter("allfixedpricecharters").SetParameter("Status", 2);
        
    }
    private void Application_EndRequest(object sender, EventArgs e)
    {
        ISession session = CurrentSessionContext.Unbind(
        NHibernateHelper.SessionFactory);
        if (session != null)
            try
            {
                session.Transaction.Commit();
            }
            catch (Exception ex)
            {
                session.Transaction.Rollback();
                //Server.Transfer("...", true); // Error page
                
            }
            finally
            {
                session.Close();
            }
    }
}
