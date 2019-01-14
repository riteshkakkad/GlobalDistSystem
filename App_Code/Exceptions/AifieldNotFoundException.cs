using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Exceptions
{
    public class AifieldNotFoundException:Exception
    {
        public AifieldNotFoundException()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public AifieldNotFoundException(String msg):base(msg)
        {
            //
            // TODO: Add constructor logic here
            //
        }
    }
}
