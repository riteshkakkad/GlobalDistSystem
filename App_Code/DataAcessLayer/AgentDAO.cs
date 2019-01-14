using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Entities;
using Iesi.Collections;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using Exceptions;
using NHibernate.Criterion;
using System.Collections.Specialized;

namespace DataAccessLayer
{
    public class AgentDAO
    {

        public AgentDAO()
        {

        }
        public static Agent MakePersistent(Agent a)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(a);
            return a;
        }
        public static Agent GetAgentByEmailPassword(String email,String password)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Agent));
            cr.Add(Restrictions.Eq("Email", email));
            cr.Add(Restrictions.Eq("Password", password));
            cr.Add(Restrictions.IsNotNull("Password"));
            cr.Add(Restrictions.Eq("Status", 1));
            return cr.UniqueResult<Agent>();
        }
        
        public static Agent FindAgentByID(Int64 id)
        {
            try
            {
                Agent a = NHibernateHelper.GetCurrentSession().Load<Agent>(id);
                return a;
            }
            catch (Exception ex)
            {
                throw new AdminException("Agent not found.");
            }
        }
        public static Agent FindAgentByCode(String Code)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Agent));
            cr.Add(Restrictions.Eq("AgentCode", Code));
            cr.Add(Restrictions.Eq("Status",1));
            return cr.UniqueResult<Agent>();
        }
        
        public static Agent GetAgentByEmail(String email)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Agent));
            cr.Add(Restrictions.Eq("Email", email));
            return cr.UniqueResult<Agent>();
        }
        public static IList<Agent> GetAgents(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForAgents(pars);

            return cr.List<Agent>();

        }
        public static IList<Agent> GetAgents(Int32 pageid, Int32 max, NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForAgents(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<Agent>();

        }
        public static ICriteria GetCriteriaForAgents(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Agent));
            if (pars.Get("status") == "pending")
                cr.Add(Restrictions.Eq("Status", 0));
            else
                cr.Add(Restrictions.Eq("Status", 1));

            if (pars.Get("country") != null)
            {
                cr.Add(Restrictions.Eq("Country", pars.Get("country")));
            }

            if (pars.Get("agencyname") != null)
            {
                cr.Add(Restrictions.Like("Agency", pars.Get("agencyname"), MatchMode.Anywhere));
            }
            if (pars.Get("email") != null)
            {
                cr.Add(Restrictions.Eq("Email", pars.Get("email")));
            }

            return cr;
        }

    }
}