using System;
using System.Data;

using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NHibernate;
using NHibernate.Cfg;

using System.Collections.Generic;
using System.Reflection;
using Entities;
using Iesi.Collections;
using DataAccessLayer;

public class NHibernateHelper
{
    public static readonly ISessionFactory SessionFactory;
    static NHibernateHelper()
    {
        try
        {
            Configuration cfg = new Configuration();
            cfg.AddAssembly(Assembly.GetCallingAssembly());
            String basePath = System.Web.HttpContext.Current.Server.MapPath(@"~/Resources/");
            cfg.AddXmlFile(basePath + "BookRequest.hbm.xml");
            cfg.AddXmlFile(basePath + "Leg.hbm.xml");
            cfg.AddXmlFile(basePath + "Airplane.hbm.xml");
            cfg.AddXmlFile(basePath + "Operator.hbm.xml");
            cfg.AddXmlFile(basePath + "OperatorRegion.hbm.xml");
            cfg.AddXmlFile(basePath + "AirplaneType.hbm.xml");
            cfg.AddXmlFile(basePath + "Airfield.hbm.xml");
            cfg.AddXmlFile(basePath + "OperatorQuote.hbm.xml");
            cfg.AddXmlFile(basePath + "OperatorQuoteLeg.hbm.xml");
            cfg.AddXmlFile(basePath + "OperatorRequest.hbm.xml");
            cfg.AddXmlFile(basePath + "Agent.hbm.xml");
            cfg.AddXmlFile(basePath + "Admin.hbm.xml");
            cfg.AddXmlFile(basePath + "Country.hbm.xml");
            cfg.AddXmlFile(basePath + "Currency.hbm.xml");
            cfg.AddXmlFile(basePath + "AirplaneTypeRate.hbm.xml");
            cfg.AddXmlFile(basePath + "OperatorBid.hbm.xml");
            cfg.AddXmlFile(basePath + "AircraftPhoto.hbm.xml");
            cfg.AddXmlFile(basePath + "EmailSetting.hbm.xml");
            cfg.AddXmlFile(basePath + "Customer.hbm.xml");
            cfg.AddXmlFile(basePath + "IpAddress.hbm.xml");
            cfg.AddXmlFile(basePath + "EmptyLeg.hbm.xml");
            cfg.AddXmlFile(basePath + "EmptyLegOffer.hbm.xml");
            cfg.AddXmlFile(basePath + "FixedPriceCharter.hbm.xml");
            cfg.Properties.Add("current_session_context_class","web");
            SessionFactory = cfg.Configure().BuildSessionFactory();

        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            throw new Exception("NHibernate initialization failed", ex);
        }
    }
    public static ISession OpenSession()
    {
        return SessionFactory.OpenSession();
    }
    public static ISession GetCurrentSession()
    {
        return SessionFactory.GetCurrentSession();
    }
}
