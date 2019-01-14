using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Entities
{
    public class Country
    {
        private String _CountryID;
        private String _FullName;
        private String _Continent;
        private Currency _Currency;
        private String _PricingDisclaimer;
        private String _CopyRight;
        private String _Signature;
        private Boolean _SendBidToCustomer;
        private Boolean _SendRequestToOperator;
        private Double _Margin;
        private String _ContactNos;
       
        public String CountryID
        {
            get { return _CountryID; }
            set { _CountryID = value; }
        }
       
        public Boolean SendRequestToOperator
        {
            get { return _SendRequestToOperator; }
            set { _SendRequestToOperator = value; }
        }
        public Boolean SendBidToCustomer
        {
            get { return _SendBidToCustomer; }
            set { _SendBidToCustomer = value; }
        }
        public Double Margin
        {
            get { return _Margin; }
            set { _Margin = value; }
        }
        public String FullName
        {
            get { return _FullName; }
            set { _FullName = value; }
        }
        public String Continent
        {
            get { return _Continent; }
            set { _Continent = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
        public Country()
        {
           
        }
        public String PricingDisclaimer
        {
            get { return _PricingDisclaimer; }
            set { _PricingDisclaimer = value; }
        }
        public String CopyRight
        {
            get { return _CopyRight; }
            set { _CopyRight = value; }
        }
        public String Signature
        {
            get { return _Signature; }
            set { _Signature = value; }
        }
        public String ContactNos
        {
            get { return _ContactNos; }
            set { _ContactNos = value; }
        }

    }
}
