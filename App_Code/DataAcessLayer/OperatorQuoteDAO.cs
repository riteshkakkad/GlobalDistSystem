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
namespace DataAccessLayer
{
    public class OperatorQuoteDAO
    {
        public OperatorQuoteDAO()
        {

        }
        public static IList<OperatorQuote> GetOperatorQuotesForBookRequest(BookRequest b)
        {
            IQuery q = NHibernateHelper.GetCurrentSession().CreateQuery("from OperatorQuote o where o.Request=:b ").SetParameter("b",b);
            return q.List<OperatorQuote>();
        }
        public static OperatorQuote GetOperatorQuote(Int64 id)
        {
            try
            {
                OperatorQuote oq = NHibernateHelper.GetCurrentSession().Load<OperatorQuote>(id);
                return oq;
            }
            catch (Exception ex)
            {
                throw new AdminException("Operator Quote not found.");
            }
        }
        public static IList<OperatorQuote> GetOperatorQuotes(BookRequest b)
        {
            IQuery q = NHibernateHelper.GetCurrentSession().CreateQuery("from OperatorQuote o where o.Request=:Request order by o.AirnetzAmount ASC").SetParameter("Request", b);
            return q.List<OperatorQuote>();

        }

    }
}
