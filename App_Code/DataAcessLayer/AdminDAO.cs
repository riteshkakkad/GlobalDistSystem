using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Iesi.Collections;
using Entities;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using Exceptions;
using NHibernate.Criterion;



namespace DataAccessLayer
{
    public class AdminDAO
    {
        public AdminDAO()
        {

        }
        public static Admin GetAdminByIDPasword(String AdminID, String AdminPassword)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Admin));
            cr.Add(Restrictions.Eq("AdminID", AdminID));
            cr.Add(Restrictions.Eq("AdminPassword", AdminPassword));
            Admin a = cr.UniqueResult<Admin>();

           return a;
        }
        public static Admin GetAdminByID(String AdminID)
        {
            Admin a = NHibernateHelper.GetCurrentSession().Load<Admin>(AdminID.Trim());
            return a;
        }
        public static IList<Currency> GetCurrencies()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Currency));
            return cr.List<Currency>();

        }
        public static IList<Country> GetFranchiseCountries()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneTypeRate));
            cr.CreateCriteria("Country").Add(Restrictions.IsNotNull("Currency")) ;
            cr.SetProjection(Projections.Distinct(Projections.Property("Country")));
            return cr.List<Country>();
        }
        public static Admin MakePersistent(Admin a)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(a);
            return a;
        }
        public static IList<EmailSetting> GetEmailSettings()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmailSetting));
            return cr.List<EmailSetting>();
        }
        public static EmailSetting GetEmailSettingByID(String id)
        {
            return NHibernateHelper.GetCurrentSession().Load<EmailSetting>(id);
        }
        public static EmailSetting MakePersistent(EmailSetting es)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(es);
            return es;
        }
        public static Country GetCountryByID(String id)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Country));
            cr.Add(Restrictions.Eq("CountryID", id));
            return cr.UniqueResult<Country>();
        }
        public static IList<String> GetContinents()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Country));
            cr.SetProjection(Projections.Distinct(Projections.Property("Continent")));
            return cr.List<String>();
        }
        public static Currency GetCurrencyByID(String id)
        {
            return NHibernateHelper.GetCurrentSession().Load<Currency>(id);
        }
        public static Currency MakePersistent(Currency c)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(c);
            return c;
        }
        public static Currency AddCurrency(Currency c)
        {
            NHibernateHelper.GetCurrentSession().Save(c);
            return c;
        }
        public static Country MakePersistent(Country c)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(c);
            return c;
        }
        public static Currency CheckCurrencyByID(String id)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Currency));
            cr.Add(Restrictions.Eq("ID", id));
            return cr.UniqueResult<Currency>();
        }
        public static String GetCountryForIpNumber(Int64 ipno)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(IpAddress));
            cr.Add(Restrictions.And(Restrictions.Le("HigherRange",ipno), Restrictions.Ge("LowerRange",ipno)));
            cr.SetProjection(Projections.Property("Country"));
            return cr.UniqueResult<String>();
         
        }

    }
}
