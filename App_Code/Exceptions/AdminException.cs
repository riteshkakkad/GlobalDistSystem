using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Exceptions
{
    public class AdminException : Exception
    {
        public AdminException()
        {

        }
        public AdminException(String msg)
            :base(msg)
        {

        }
    }
}
