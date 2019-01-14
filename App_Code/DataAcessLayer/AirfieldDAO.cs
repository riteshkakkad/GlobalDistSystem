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
using System.Collections.Specialized;


namespace DataAccessLayer
{
    public class AirfieldDAO
    {
        public AirfieldDAO()
        {
           
        }
        public static Airfield MakePersistent(Airfield a)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(a);
            
            return a;
        }
        public static Airfield AddAirfield(Airfield a)
        {
            NHibernateHelper.GetCurrentSession().Save(a);

            return a;
        }

        public static Airfield FindAirfieldByID(String ICAOCODE)
        {
            try
            {

                Airfield a = NHibernateHelper.GetCurrentSession().Load<Airfield>(ICAOCODE);
                return a;
            }
            catch (Exception ex)
            {
                throw new Exception("Airfields Not Found. Use Autocomplete feature.");
            }
            
        }
        public static IList<Airfield> FindAirfieldsStartingWith(String value,Int32 max)
        {
            IList<Airfield> airfields = null;
            try
            {
                IQuery q = NHibernateHelper.GetCurrentSession().CreateQuery("from Airfield a where a.AirfieldName Like '%" + value + "%'").SetMaxResults(max);
                airfields = q.List<Airfield>();
            }
            catch (Exception ex)
            {
                throw new InvalidFieldException("Airfields not found");
            }
            return airfields;
        }
        public static IList<Airfield> FindByAirfieldName(String value,String matchmode)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            MatchMode m = null;
            switch (matchmode)
            {
                case "Start": m = MatchMode.Start; break;
                case "Exact": m = MatchMode.Exact; break; 
                default: m = MatchMode.Anywhere; break;
            }
            cr.Add(Restrictions.Like("AirfieldName",value,m));
            return cr.List<Airfield>();
        }
        public static Airfield FindExactAirfield(Airfield a)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Eq("AirfieldName", a.AirfieldName));
            cr.Add(Restrictions.Eq("LattitudeDegrees", a.LattitudeDegrees));
            cr.Add(Restrictions.Eq("LattitudeMinutes", a.LattitudeMinutes));
            cr.Add(Restrictions.Eq("NS", a.NS));
            cr.Add(Restrictions.Eq("LongitudeDegrees", a.LongitudeDegrees));
            cr.Add(Restrictions.Eq("LongitudeMinutes", a.LongitudeMinutes));
            cr.Add(Restrictions.Eq("EW",a.EW));
            return cr.UniqueResult<Airfield>();
        }
        public static IList<Airfield> FindSimilarAirfieldsByName(String value,String country)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            Conjunction c = new Conjunction();
            foreach (String s in value.Split(" ".ToCharArray()))
            {
               c.Add(Restrictions.Like("AirfieldName",s,MatchMode.Anywhere));
                
            }
            cr.Add(c);
            cr.Add(Restrictions.Eq("Country",country));
            return cr.List<Airfield>();
        }
        public static Airfield FindAirfieldByIATA(String code)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Eq("IATACode", code));
            return cr.UniqueResult<Airfield>();
        }
        public static Airfield FindAirfieldByICAO(String code)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Eq("ICAOCODE", code));
            return cr.UniqueResult<Airfield>();
        }
        public static IList<Airfield> FindAirfieldByCity(String value,String matchmode)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            MatchMode m = null;
            switch (matchmode)
            {
                case "Start": m = MatchMode.Start; break;
                default: m = MatchMode.Anywhere; break;
            }
            cr.Add(Restrictions.Like("City", value, m));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> FindAirfieldByState(String value, String matchmode)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            MatchMode m = null;
            switch (matchmode)
            {
                case "Start": m = MatchMode.Start; break;
                default: m = MatchMode.Anywhere; break;
            }
            cr.Add(Restrictions.Like("State", value, m));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> FindAirfieldByAlternativeNames(String value)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Like("AlternativeNames", value, MatchMode.Anywhere));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> GetAirfields()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> GetAirfields(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForAirfieldSearch(pars);
            return cr.List<Airfield>();
        }
        public static IList<Airfield> GetAirfields(NameValueCollection pars,Int32 pageid,Int32 max)
        {
            ICriteria cr = GetCriteriaForAirfieldSearch(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<Airfield>();
        }
        public static ICriteria GetCriteriaForAirfieldSearch(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            if (pars.Get("country") != null)
            {
                cr.Add(Restrictions.Eq("Country", pars.Get("country")));
            }
            else
            {
                cr.Add(Restrictions.Eq("Country", "IN"));
            }
            if (pars.Get("state") != null)
            {
                cr.Add(Restrictions.Eq("State", pars.Get("state")));
            }
            if (pars.Get("city") != null)
            {
                cr.Add(Restrictions.Eq("City", pars.Get("city")));
            }
            if (pars.Get("icao") != null)
            {
                cr.Add(Restrictions.Eq("ICAOCODE", pars.Get("icao")));
            }
            return cr;
        }
        public static IList<Airfield> GetAutoassignedHeliports()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Like("ICAOCODE","A-A",MatchMode.Start));
            cr.AddOrder(new Order("ICAOCODE",false));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> GetAutoassignedAirfields()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Like("ICAOCODE", "B-B", MatchMode.Start));
            cr.AddOrder(new Order("ICAOCODE", false));
            return cr.List<Airfield>();
        }
        public static IList<Airfield> GetAutoassignedTemporary()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Airfield));
            cr.Add(Restrictions.Like("ICAOCODE", "T-T", MatchMode.Start));
            cr.AddOrder(new Order("ICAOCODE", false));
            return cr.List<Airfield>();
        }

        
    }
}
