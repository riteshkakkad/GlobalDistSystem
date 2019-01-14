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
    public class Currency
    {
        private String _ID;
        private String _FullName;
        private String _ShortName;
        private Double _Rate;
        private DateTime _TimeOfRate;

        public String ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public String FullName
        {
            get { return _FullName; }
            set { _FullName = value; }
        }
        public String ShortName
        {
            get { return _ShortName; }
            set { _ShortName = value; }
        }
        public Double Rate
        {
            get { return _Rate; }
            set { _Rate = value; }
        }
        public DateTime TimeOfRate
        {
            get { return _TimeOfRate; }
            set { _TimeOfRate = value; }
        }
        public Currency()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public Double ConvertTo(Double amount, Currency c)
        {
            String targetcurrecy = c.ID;
            Double targetcurrencyvalue = c.Rate;
            String sourcecurrency = this.ID;
            Double sourcecurrencyvalue = this.Rate;
            return Math.Round(amount * targetcurrencyvalue / sourcecurrencyvalue);

        }
    }
}
