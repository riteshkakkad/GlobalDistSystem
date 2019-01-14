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
    public class OperatorDAO
    {

        public static Operator MakePersistent(Operator op)
        {
            
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(op);
            return op;
        }
        public static OperatorQuote MakePersistent(OperatorQuote oq)
        {
            
                NHibernateHelper.GetCurrentSession().SaveOrUpdate(oq);
                return oq;
            
        }
        
        public static AirplaneType FindAircraftTypeByID(String id)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneType));
            cr.Add(Restrictions.Eq("PlaneTypeID", id));
            return cr.UniqueResult<AirplaneType>();
        }
        public static void RemoveAirplaneType(AirplaneType a)
        {
            NHibernateHelper.GetCurrentSession().Delete(a);
        }
        public static Operator FindOperatorByID(Int64 id)
        {
            try
            {
                Operator op = NHibernateHelper.GetCurrentSession().Load<Operator>(id);
               
                return op;
            }
            catch (Exception ex)
            {
                throw new AdminException("Operator not found.");
            }
        }
        public static Airplane FindAircraftByID(Int64 id)
        {
            try
            {
                Airplane a = NHibernateHelper.GetCurrentSession().Load<Airplane>(id);
               
                return a;
            }
            catch (Exception ex)
            {
                throw new AdminException("Invalid Aircraft.");
            }
        }
        public static AirplaneType FindAircraftTypeByName(String PlaneTypeName)
        {
            return (AirplaneType)NHibernateHelper.GetCurrentSession().CreateQuery("from AirplaneType Where PlaneTypeName=:PlaneTypeName").SetString("PlaneTypeName", PlaneTypeName).UniqueResult();

        }
        
        public static IList<Operator> GetOperators(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForOperators(pars);
           
            return cr.List<Operator>();
            
        }
        public static IList<Operator> GetOperators(Int32 pageid, Int32 max, NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForOperators(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<Operator>();

        }
        public static ICriteria GetCriteriaForOperators(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Operator));
            if(pars.Get("status")=="pending")
                cr.Add(Restrictions.Eq("Status", 0));
            else
                cr.Add(Restrictions.Eq("Status", 1));

            if (pars.Get("country") != null)
            {
                cr.Add(Restrictions.Eq("Country", pars.Get("country")));
            }
            if (pars.Get("opname") != null)
            {
                cr.Add(Restrictions.Like("CompanyName", pars.Get("opname"),MatchMode.Anywhere));
            }
            if (pars.Get("nsopregno") != null)
            {
                cr.Add(Restrictions.Eq("NSOPRegNo", pars.Get("nsopregno")));
            }
            if (pars.Get("email") != null)
            {
                cr.Add(Restrictions.Eq("Email", pars.Get("email")));
            }

            return cr;
        }
        public static IList<AirplaneType> GetAirplaneTypes()
        {
            IQuery q = NHibernateHelper.GetCurrentSession().CreateQuery("from AirplaneType");
            return q.List<AirplaneType>();
        }
        
        public OperatorDAO()
        {
        }
        
        
        public static Operator GetOperatorByEmail(String email)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Operator));
            cr.Add(Restrictions.Eq("Email",email));
            
             return cr.UniqueResult<Operator>();
        }
        public static IList<AirplaneType> GetPlaneTypesForSession()
        {
            String country = HttpContext.Current.Session["Country"].ToString();
            
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneTypeRate));
            cr.Add(Restrictions.Eq("Country", GetCountry(country)));
            cr.SetProjection(Projections.Property("PlaneType"));
            cr.AddOrder(new Order("RateID",true));
             return cr.List<AirplaneType>();

        }
        public static Country GetCountry(String id)
        {
           return NHibernateHelper.GetCurrentSession().Load<Country>(id);
        }
        public static IList<Country> GetCountries()
        {
            return NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Country)).List<Country>();
        }
        public static IList<Country> GetCountriesWithCurrency()
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Country));
            cr.Add(Restrictions.IsNotNull("Currency"));
            return cr.List<Country>();
        }
        public static IList<AirplaneType> GetPlaneTypes()
        {
            return NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneType)).List<AirplaneType>();
        }
        public static AirplaneType SaveAirplaneType(AirplaneType a)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(a);
            return a;
        }
        public static AirplaneType AddAirplaneType(AirplaneType a)
        {
            NHibernateHelper.GetCurrentSession().Save(a);
            return a;
        }
        public static IList<AirplaneTypeRate> GetAllRates(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneTypeRate));
            Country c = AdminDAO.GetCountryByID(pars.Get("country"));
            if (pars.Get("country") != null)
            {
                cr.Add(Restrictions.Eq("Country", c));
            }
            AirplaneType at = OperatorDAO.FindAircraftTypeByID(pars.Get("aircrafttype"));
            if (pars.Get("aircrafttype") != null)
            {
                cr.Add(Restrictions.Eq("PlaneType", at));
            }
            
            
            cr.AddOrder(new Order("Country",false));
            return cr.List<AirplaneTypeRate>();
        }
        public static AirplaneTypeRate SavePlanetypeRate(AirplaneTypeRate atr)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(atr);
            return atr;
        }
        public static AirplaneTypeRate AddPlanetypeRate(AirplaneTypeRate atr)
        {
            NHibernateHelper.GetCurrentSession().Save(atr);
            return atr;
        }
        public static AirplaneTypeRate GetAirplaneTypeRateByID(Int64 id)
        {
           return NHibernateHelper.GetCurrentSession().Load<AirplaneTypeRate>(id);
        }
        public static IList<AirplaneTypeRate> GetRateForCountryAndAirplaneType(AirplaneType at, Country c)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(AirplaneTypeRate));
            cr.Add(Restrictions.Eq("Country",c));
            cr.Add(Restrictions.Eq("PlaneType",at));
            return cr.List<AirplaneTypeRate>();
        }
        public static Operator GetOperatorByLoginEmail(String email)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Operator));
            cr.Add(Restrictions.Eq("Email",email));
            return cr.UniqueResult<Operator>();            

        }
        public static Operator VerifyOperator(String email, String password)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(Operator));
            cr.Add(Restrictions.Conjunction().Add(Restrictions.Eq("Email",email)).Add(Restrictions.Eq("Password",password)).Add(Restrictions.Eq("Status",1)));
            return cr.UniqueResult<Operator>();
        }
        public static Airplane MakePersistent(Airplane a)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(a);
            return a;
        }
        
       
        public static AircraftPhoto MakePersistent(AircraftPhoto p)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(p);
            return p;
        }
        public static AircraftPhoto FindAircraftPhotoByID(Int64 id)
        {
            return NHibernateHelper.GetCurrentSession().Load<AircraftPhoto>(id);
        }
        public static IList<Operator> GetOperatorRequests(BookRequest b)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));
            cr.Add(Restrictions.Eq("Request",b));
            cr.SetProjection(Projections.Property("Operator"));
            return cr.List<Operator>();
        }
    }
}
