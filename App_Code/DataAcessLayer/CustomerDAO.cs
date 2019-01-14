using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Entities;
using NHibernate;
using NHibernate.Criterion;
using Iesi.Collections;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace DataAccessLayer
{
    public class CustomerDAO
    {
        public CustomerDAO()
        {

        }
        public static Customer FindCustomerByID(Int64 id)
        {
            return NHibernateHelper.GetCurrentSession().Load<Customer>(id);
        }
        public static Customer CheckCustomerByEmail(String email)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Customer));
            cr.Add(Restrictions.Eq("Email",email));
           
            return cr.UniqueResult<Customer>();

        }
        public static Customer MakePersistent(Customer c)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(c);
            return c;
        }
        public static Customer CheckCustomerByEmailPassword(String email,String password)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Customer));
            cr.Add(Restrictions.Eq("Email", email));
            cr.Add(Restrictions.Eq("Password", password));
         
            return cr.UniqueResult<Customer>();

        }
        public static IList<Customer> GetCustomers(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForCustomers(pars);

            return cr.List<Customer>();

        }
        public static IList<Customer> GetCustomers(Int32 pageid, Int32 max, NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForCustomers(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<Customer>();

        }
        public static ICriteria GetCriteriaForCustomers(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Customer));
            if (pars.Get("status") == "pending")
                cr.Add(Restrictions.Eq("Status", 0));
            else
                cr.Add(Restrictions.Eq("Status", 1));

            if (pars.Get("name") != null)
            {
                cr.Add(Restrictions.Like("Name", pars.Get("name"), MatchMode.Anywhere));
            }
            if (pars.Get("email") != null)
            {
                cr.Add(Restrictions.Eq("Email", pars.Get("email")));
            }

            return cr;
        }
    }
}
