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
    public class IpAddress
    {
        private Int64 _ID;
        private Int64 _LowerRange;
        private Int64 _HigherRange;
        private String _Country;

        public IpAddress()
        {
            
        }
        public Int64 ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public Int64 LowerRange
        {
            get { return _LowerRange; }
            set { _LowerRange = value; }
        }
        public Int64 HigherRange
        {
            get { return _HigherRange; }
            set { _HigherRange = value; }
        }
        public String Country
        {
            get { return _Country; }
            set { _Country = value; }
        }

    }
}
