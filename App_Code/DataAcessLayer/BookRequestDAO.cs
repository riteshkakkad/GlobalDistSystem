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
using BusinessLayer;
namespace DataAccessLayer
{
    public class BookRequestDAO
    {
        public static BookRequest MakePersistent(BookRequest book)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(book);
            return book;

        }
        public static BookRequest FindBookRequestByID(Int64 id)
        {
            try
            {
                BookRequest b = NHibernateHelper.GetCurrentSession().Load<BookRequest>(id);
                if (b.Status == 2)
                    throw new Exception();
                return b;
            }
            catch (Exception ex)
            {
                throw new AdminException("Request not found.");
            }
        }

        public static IList<BookRequest> GetBookRequests(NameValueCollection pars, Int32 pageid, Int32 max)
        {
            ICriteria cr = GetCriteriaForBookRequests(pars);

            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<BookRequest>();
        }
        public static IList<BookRequest> GetBookRequests(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForBookRequests(pars);
            return cr.List<BookRequest>();
        }
        public static ICriteria GetCriteriaForBookRequests(NameValueCollection pars)
        {
            Agent a = AgentBO.GetLoggedInAgent();
            Customer c = CustomerBO.GetLoggedInCustomer();

            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(BookRequest));
            cr.AddOrder(new Order("TimeofCreation", false));
            if (pars.Get("triptype") != null)
                cr.Add(Restrictions.Eq("TripType", pars.Get("triptype")));

            if (pars.Get("name") != null)
                cr.Add(Restrictions.Eq("ContactDetails.Name", pars.Get("name")));

            if (pars.Get("email") != null)
                cr.Add(Restrictions.Eq("ContactDetails.Email", pars.Get("email")));

            if (pars.Get("agentid") != null)
                cr.Add(Restrictions.Eq("Agent", AgentDAO.FindAgentByID(Int64.Parse(pars.Get("agentid")))));

            if (a != null)
                cr.Add(Restrictions.Eq("Agent", a));

            if (c != null)
                cr.Add(Restrictions.Eq("ContactDetails.Email", c.Email));

            if (pars.Get("status") != null)
            {
                cr.Add(Restrictions.Eq("Status", Int16.Parse(pars.Get("status"))));
            }
            else
            {
                cr.Add(Restrictions.Eq("Status", (short)0));
            }


            if (pars.Get("aircrafttype") != null)
                cr.Add(Restrictions.Eq("PlaneType", OperatorDAO.FindAircraftTypeByID(pars.Get("aircrafttype"))));

            return cr;
        }
        public static IList<OperatorRequest> GetOperatorRequests(BookRequest b)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));
            cr.Add(Restrictions.Eq("Request", b));

            return cr.List<OperatorRequest>();
        }
        public static IList<OperatorRequest> GetOperatorRequests(Operator o)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));
            cr.Add(Restrictions.Eq("Operator", o));
            cr.SetResultTransformer(CriteriaUtil.DistinctRootEntity);
            return cr.List<OperatorRequest>();
        }
        public static IList<Operator> GetRequestedOperators(BookRequest b)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));
            cr.Add(Restrictions.Eq("Request", b));
            cr.SetProjection(Projections.Property("Operator"));
            cr.SetResultTransformer(CriteriaUtil.DistinctRootEntity);
            return cr.List<Operator>();
        }
        public static OperatorRequest GetOperatorRequestByOperator(Operator o, BookRequest b)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));
            cr.Add(Restrictions.Eq("Request", b));
            cr.Add(Restrictions.Eq("Operator", o));
            return cr.UniqueResult<OperatorRequest>();
        }
        public static OperatorRequest MakePersistent(OperatorRequest or)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(or);
            return or;
        }
        public static IList<BookRequest> GetBookRequests(Operator o, NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));

            cr.Add(Restrictions.Eq("Operator", o));
            cr.AddOrder(new Order("TimeOfRequest", false));
            cr.SetProjection(Projections.Property("Request"));
            if (pars.Get("status") != null)
            {
                cr.CreateCriteria("Request").Add(Restrictions.Eq("Status", Int16.Parse(pars.Get("status"))));
            }
            else
            {
                cr.CreateCriteria("Request").Add(Restrictions.Eq("Status", (short)0));
            }
            return cr.List<BookRequest>();

        }
        public static IList<BookRequest> GetBookRequests(Operator o, NameValueCollection pars, Int32 pageid, Int32 max)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorRequest));

            cr.Add(Restrictions.Eq("Operator", o));
            cr.AddOrder(new Order("TimeOfRequest", false));
            cr.SetProjection(Projections.Property("Request"));
            if (pars.Get("status") != null)
            {
                cr.CreateCriteria("Request").Add(Restrictions.Eq("Status", Int16.Parse(pars.Get("status"))));
            }
            else
            {
                cr.CreateCriteria("Request").Add(Restrictions.Eq("Status", (short)0));
            }
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<BookRequest>();
        }
        public static IList<OperatorBid> GetBidsForRequest(BookRequest b)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorBid));
            cr.Add(Restrictions.Eq("Request", b));
            cr.Add(Restrictions.Not(Restrictions.Eq("Status", (short)2)));
            cr.AddOrder(new Order("TimeOfBid", false));
            return cr.List<OperatorBid>();
        }
        public static IList<OperatorBid> GetAllBids(NameValueCollection pars, Int32 pageid, Int32 max)
        {
            ICriteria cr = GetCriteriaForBids(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<OperatorBid>();
        }
        public static IList<OperatorBid> GetBidsOfOperator(Operator o)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorBid));
            cr.Add(Restrictions.Eq("Operator", o));
            return cr.List<OperatorBid>();
        }
        public static IList<OperatorBid> GetBidsOfAircraft(Airplane a)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorBid));
            cr.Add(Restrictions.Eq("Aircraft", a));
            return cr.List<OperatorBid>();
        }
        public static IList<OperatorBid> GetAllBids(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForBids(pars);
            return cr.List<OperatorBid>();
        }
        public static ICriteria GetCriteriaForBids(NameValueCollection pars)
        {
            Agent a = AgentBO.GetLoggedInAgent();
            Customer c = CustomerBO.GetLoggedInCustomer();

            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(OperatorBid));
            cr.Add(Restrictions.Eq("Status", (short)1));

            if (a != null)
                cr.CreateCriteria("Request").Add(Restrictions.Eq("Agent", a));

            if (c != null)
                cr.CreateCriteria("Request").Add(Restrictions.Eq("ContactDetails.Email", c.Email));

            if (pars.Get("bookrequest") != null)
                cr.Add(Restrictions.Eq("Request", BookRequestDAO.FindBookRequestByID(Int64.Parse(pars.Get("bookrequest")))));

            if (pars.Get("sortby") != null)
            {
                if (pars.Get("sortby") == "time")
                    cr.AddOrder(new Order("TimeOfBid", false));

                if (pars.Get("sortby") == "amount")
                    cr.AddOrder(new Order("BidAmount", true));
            }
            else
            {
                cr.AddOrder(new Order("TimeOfBid", false));
            }

            return cr;
        }


        public static OperatorBid SaveBid(OperatorBid ob)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(ob);
            return ob;
        }
        public static OperatorBid GetOperatorBidByID(Int64 id)
        {
            OperatorBid ob = NHibernateHelper.GetCurrentSession().Load<OperatorBid>(id);
            return ob;
        }
        public static EmptyLeg MakePersistent(EmptyLeg el)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(el);
            return el;
        }
        public static EmptyLegOffer MakePersistent(EmptyLegOffer elo)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(elo);
            return elo;
        }
        public static FixedPriceCharter MakePersistent(FixedPriceCharter fpc)
        {
            NHibernateHelper.GetCurrentSession().SaveOrUpdate(fpc);
            return fpc;
        }
        public static IList<EmptyLegOffer> GetEmptyLegBids(EmptyLeg el)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLegOffer));
            cr.Add(Restrictions.Eq("EmptyLeg", el));
            cr.AddOrder(new Order("TimeOfOffer", false));
            return cr.List<EmptyLegOffer>();
        }
        public static IList<EmptyLeg> GetEmptyLegs(Customer c)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLegOffer));
            cr.Add(Restrictions.Eq("Customer", c));
            cr.SetProjection(Projections.Property("EmptyLeg"));
            cr.SetResultTransformer(CriteriaUtil.DistinctRootEntity);
            return cr.List<EmptyLeg>();
        }
        public static IList<EmptyLeg> GetEmptyLegs(Agent a)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLegOffer));
            cr.Add(Restrictions.Eq("Agent", a));
            cr.SetProjection(Projections.Property("EmptyLeg"));
            cr.SetResultTransformer(CriteriaUtil.DistinctRootEntity);
            return cr.List<EmptyLeg>();
        }
        public static IList<EmptyLegOffer> GetEmptyLegBids(EmptyLeg el, Customer c)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLegOffer));
            cr.Add(Restrictions.Eq("EmptyLeg", el));
            cr.Add(Restrictions.Eq("Customer", c));
            cr.AddOrder(new Order("TimeOfOffer", false));
            return cr.List<EmptyLegOffer>();
        }
        public static IList<EmptyLegOffer> GetEmptyLegBids(EmptyLeg el, Agent a)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLegOffer));
            cr.Add(Restrictions.Eq("EmptyLeg", el));
            cr.Add(Restrictions.Eq("Agent", a));
            cr.AddOrder(new Order("TimeOfOffer", false));
            return cr.List<EmptyLegOffer>();
        }

        public static IList<EmptyLeg> GetEmptyLegs(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForEmptyLegs(pars);
            return cr.List<EmptyLeg>();
        }
        public static IList<EmptyLeg> GetEmptyLegs(NameValueCollection pars, Int32 pageid, Int32 max)
        {
            ICriteria cr = GetCriteriaForEmptyLegs(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<EmptyLeg>();
        }
        public static IList<FixedPriceCharter> GetFixedPriceCharters(NameValueCollection pars)
        {
            ICriteria cr = GetCriteriaForFixedPriceCharters(pars);
            return cr.List<FixedPriceCharter>();
        }
        public static IList<FixedPriceCharter> GetFixedPriceCharters(NameValueCollection pars, Int32 pageid, Int32 max)
        {
            ICriteria cr = GetCriteriaForFixedPriceCharters(pars);
            cr.SetFirstResult((pageid - 1) * max).SetMaxResults(max);
            return cr.List<FixedPriceCharter>();
        }
        public static EmptyLeg FindEmptyLegByID(Int64 id)
        {
            return NHibernateHelper.GetCurrentSession().Load<EmptyLeg>(id);
        }
        public static FixedPriceCharter FindFixedPriceCharterByID(Int64 id)
        {
            return NHibernateHelper.GetCurrentSession().Load<FixedPriceCharter>(id);
        }
        public static EmptyLegOffer FindEmptyLegOfferByID(Int64 id)
        {
            return NHibernateHelper.GetCurrentSession().Load<EmptyLegOffer>(id);
        }
        public static ICriteria GetCriteriaForEmptyLegs(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(EmptyLeg));
            if (!HttpContext.Current.User.IsInRole("Admin") && !HttpContext.Current.User.IsInRole("Operators"))
            {
                cr.Add(Restrictions.IsNull("AcceptedOffer"));
            }

            Operator o = OperatorBO.GetLoggedinOperator();
            if (o != null)
                cr.CreateCriteria("Aircraft").Add(Restrictions.Eq("Vendor", o));

            if (pars.Get("operator") != null)
                cr.CreateCriteria("Aircraft").CreateCriteria("Vendor").Add(Restrictions.Like("CompanyName", pars.Get("operator"), MatchMode.Anywhere));

            if (pars.Get("source") != null)
            {
                cr.CreateCriteria("Source")
                    .Add(Restrictions.Disjunction()
                    .Add(Restrictions.Like("AirfieldName", pars.Get("source"), MatchMode.Anywhere))
                    .Add(Restrictions.Eq("ICAOCODE", pars.Get("source")))
                    .Add(Restrictions.Eq("City", pars.Get("source")))
                    );
            }
            if (pars.Get("destination") != null)
            {
                cr.CreateCriteria("Destination")
                    .Add(Restrictions.Disjunction()
                    .Add(Restrictions.Like("AirfieldName", pars.Get("destination"), MatchMode.Anywhere))
                    .Add(Restrictions.Eq("ICAOCODE", pars.Get("destination")))
                    .Add(Restrictions.Eq("City", pars.Get("destination")))
                    );
            }
            if (pars.Get("status") != null)
            {
                cr.Add(Restrictions.Eq("Status", Int32.Parse(pars.Get("status"))));
            }
            else
            {
                cr.Add(Restrictions.Eq("Status", 1));
            }
            cr.AddOrder(new Order("PostedOn", false));
            return cr;
        }
        public static ICriteria GetCriteriaForFixedPriceCharters(NameValueCollection pars)
        {
            ICriteria cr = NHibernateHelper.GetCurrentSession().CreateCriteria(typeof(FixedPriceCharter));
            
            Operator o = OperatorBO.GetLoggedinOperator();
            if (o != null)
                cr.CreateCriteria("Aircraft").Add(Restrictions.Eq("Vendor", o));

            if (pars.Get("operator") != null)
                cr.CreateCriteria("Aircraft").CreateCriteria("Vendor").Add(Restrictions.Like("CompanyName", pars.Get("operator"), MatchMode.Anywhere));

            if (pars.Get("source") != null)
            {
                cr.CreateCriteria("Source")
                    .Add(Restrictions.Disjunction()
                    .Add(Restrictions.Like("AirfieldName", pars.Get("source"), MatchMode.Anywhere))
                    .Add(Restrictions.Eq("ICAOCODE", pars.Get("source")))
                    .Add(Restrictions.Eq("City", pars.Get("source")))
                    );
            }
            if (pars.Get("destination") != null)
            {
                cr.CreateCriteria("Destination")
                    .Add(Restrictions.Disjunction()
                    .Add(Restrictions.Like("AirfieldName", pars.Get("destination"), MatchMode.Anywhere))
                    .Add(Restrictions.Eq("ICAOCODE", pars.Get("destination")))
                    .Add(Restrictions.Eq("City", pars.Get("destination")))
                    );
            }
            if (pars.Get("status") != null)
            {
                cr.Add(Restrictions.Eq("Status", Int32.Parse(pars.Get("status"))));
            }
            else
            {
                cr.Add(Restrictions.Eq("Status", 1));
            }
            cr.AddOrder(new Order("PostedOn", false));
            return cr;
        }



    }
}
