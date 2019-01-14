<%@ WebHandler Language="C#" Class="UpdateRegistration" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using Helper;
using BusinessLayer;
using System.Web.SessionState;
public class UpdateRegistration : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("operatoradd") != null)
        {

            try
            {

                if (OperatorDAO.GetOperatorByEmail(context.Request.Params.Get("Email")) != null)
                    throw new NHibernate.HibernateException();

                Operator op = new Operator();

                op.CompanyName = context.Request.Params.Get("OperatorName");
                op.Password = context.Request.Params.Get("Password");
                op.Address = context.Request.Params.Get("Address");
                op.ContactNo = context.Request.Params.Get("ContactNo");
                op.Email = context.Request.Params.Get("Email");
                op.ContactNo1 = context.Request.Params.Get("AlternateContactNo");
                op.Email1 = context.Request.Params.Get("AlternateEmail");
                op.Country = context.Request.Params.Get("country");
                op.NSOPRegNo = context.Request.Params.Get("NSOPRegNo");
                foreach (String s in context.Request.Params.Get("countries").Split(",".ToCharArray()))
                {
                    op.OperatorCountries.Add(s);
                }
                op.Status = 0;
                OperatorDAO.MakePersistent(op);
                EmailBO em = new EmailBO("OperatorRegistrationThanks", "US");
                em.SendEmailToOperator(op);
                String resp = "";
                resp += "{'success':'1','text':'Thank You.The registration details have been sent to the Airnetz Administration.You will receive an email shortly depending upon approval.'}";
                context.Response.Write(resp);

            }
            catch (NHibernate.HibernateException hx)
            {
                String resp = "";
                resp += "{'error':'1','text':'Login email already present.'}";
                context.Response.Write(resp);

            }
            catch (Exception ex)
            {

                String resp = "";
                resp += "{'error':'1','text':'Some unexpected problem occured.'}";
                context.Response.Write(resp);

            }
        }
        if (context.Request.Params.Get("customeradd") != null)
        {
            try
            {

                if (CustomerDAO.CheckCustomerByEmail(context.Request.Params.Get("Email")) != null)
                    throw new NHibernate.HibernateException();

                Customer c = new Customer();

                c.CompanyName = context.Request.Params.Get("CompanyName");
                c.Name = context.Request.Params.Get("Name");
                c.Password = context.Request.Params.Get("Password");
                c.Address = context.Request.Params.Get("Address");
                c.ContactNo = context.Request.Params.Get("ContactNo");
                c.Email = context.Request.Params.Get("Email");
                c.ContactNo1 = context.Request.Params.Get("AlternateContactNo");
                c.Email1 = context.Request.Params.Get("AlternateEmail");
                c.Country = context.Request.Params.Get("country");
                c.Status = 1;
                CustomerDAO.MakePersistent(c);
                EmailBO em = new EmailBO("NewCustomer", context.Session["Country"].ToString());
                em.SendEmailToCustomer(c);
                String resp = "";
                resp += "{'success':'1','text':'Thank you for the registration with Airnetz Charter Inc. Please <a href=\"Customer/Login.aspx\">Login</a> to Proceed.'}";
                context.Response.Write(resp);

            }
            catch (NHibernate.HibernateException hx)
            {
                String resp = "";
                resp += "{'error':'1','text':'Login email already present.'}";
                context.Response.Write(resp);

            }
            catch (Exception ex)
            {

                String resp = "";
                resp += "{'error':'1','text':'Some unexpected problem occured.'}";
                context.Response.Write(resp);

            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}