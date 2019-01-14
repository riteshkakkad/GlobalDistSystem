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
using DataAccessLayer;
using Helper;

namespace BusinessLayer
{
    public class AgentBO
    {
        public AgentBO()
        {

        }
        public static String GeneratePassword()
        {
            return RandomPassword.Generate(8);
        }
        public static Agent GetLoggedInAgent()
        {
            try
            {
                if (HttpContext.Current.User.IsInRole("Agent"))
                {
                    Agent a = AgentDAO.FindAgentByID(Int64.Parse(HttpContext.Current.User.Identity.Name));
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
        public static Agent CheckAgentCode(String AgentCode)
        {
            
               Agent a=AgentDAO.FindAgentByCode(AgentCode);
               return a;
                   
        }


    }
}
