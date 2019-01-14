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
    public class InvalidFieldException: Exception
    {
        public InvalidFieldException()
        {
            
        }
        public InvalidFieldException(String msg)
            :base(msg)
        {

        }
    }
}
