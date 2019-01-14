using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DataAccessLayer;
using Entities;
using Helper;

namespace BusinessLayer
{
    public class CustomerBO
    {
        public CustomerBO()
        {
            
        }
        public static String GeneratePassword()
        {
            return RandomPassword.Generate(8);
        }
        public static Customer GetLoggedInCustomer()
        {
            try
            {
                if (HttpContext.Current.User.IsInRole("Customer"))
                {
                    Customer a = CustomerDAO.FindCustomerByID(Int64.Parse(HttpContext.Current.User.Identity.Name));
                    return a;
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
