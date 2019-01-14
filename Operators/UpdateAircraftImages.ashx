<%@ WebHandler Language="C#" Class="UpdateAircraftImages" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Drawing;
using System.Drawing.Drawing2D;
using BusinessLayer;
using Iesi.Collections;
using System.IO;

public class UpdateAircraftImages : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("savecaption") != null)
        {
            Operator op = OperatorBO.GetLoggedinOperator();
            AircraftPhoto ap = OperatorDAO.FindAircraftPhotoByID(Int64.Parse(context.Request.Params.Get("pid")));
            ListSet ls = new ListSet();
            foreach (Airplane a in op.Aircrafts)
            {
                ls.AddAll(a.PhotoList);
            }
            if (ls.Contains(ap))
            {
                ap.Caption = context.Request.Params.Get("caption").Trim();
            }
            OperatorDAO.MakePersistent(ap);
        }
        if (context.Request.Params.Get("setdisplaystatus") != null)
        {
            Operator op = OperatorBO.GetLoggedinOperator();
            AircraftPhoto ap = OperatorDAO.FindAircraftPhotoByID(Int64.Parse(context.Request.Params.Get("pid")));
            ListSet ls = new ListSet();
            foreach (Airplane a in op.Aircrafts)
            {
                ls.AddAll(a.PhotoList);
            }
            if (ls.Contains(ap))
            {
                foreach (AircraftPhoto p in ap.Aircraft.PhotoList)
                {
                    if (p.Equals(ap))
                    {
                        p.DisplayPic = true;
                    }
                    else
                    {
                        p.DisplayPic = false;
                    }
                    OperatorDAO.MakePersistent(p);
                }
                
            }
        }
        if (context.Request.Params.Get("removephoto") != null)
        {
            Operator op = OperatorBO.GetLoggedinOperator();
            AircraftPhoto ap = OperatorDAO.FindAircraftPhotoByID(Int64.Parse(context.Request.Params.Get("pid")));
            ListSet ls = new ListSet();
            foreach (Airplane a in op.Aircrafts)
            {
                ls.AddAll(a.PhotoList);
            }
            if (ls.Contains(ap))
            {
                //File.Delete(context.Server.MapPath(@"../aircraftphotos/" + ap.PhotoID + ".jpeg"));               
                NHibernateHelper.GetCurrentSession().Delete(ap);
                ap.Aircraft.PhotoList.Remove(ap);
                context.Response.Redirect(context.Request.UrlReferrer.OriginalString);

            }
        }
        if (context.Request.Params.Get("addphoto") != null)
        {
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aid")));
            Operator op = OperatorBO.GetLoggedinOperator();

            if (op.Aircrafts.Contains(a))
            {
                AircraftPhoto p = new AircraftPhoto();
                p.Aircraft = a;
                p.DisplayPic = false;
                OperatorDAO.MakePersistent(p);
                System.Drawing.Image i = System.Drawing.Image.FromStream(context.Request.Files.Get("Filedata").InputStream);
                context.Request.Files.Get("Filedata").InputStream.Dispose();
                if (i.Width < 400)
                {
                    i.Save(context.Server.MapPath("~/aircraftphotos") + "/" + p.PhotoID + ".jpeg", System.Drawing.Imaging.ImageFormat.Jpeg);
                    i.Dispose();
                }
                else
                {
                    System.Drawing.Image i2 = resizeImage(i, new Size(400, 400));
                    i2.Save(context.Server.MapPath("~/aircraftphotos") + "/" + p.PhotoID + ".jpeg", System.Drawing.Imaging.ImageFormat.Jpeg);
                    i2.Dispose(); 
                }

            }
            context.Response.Write("success");
        }

    }


    private static System.Drawing.Image resizeImage(System.Drawing.Image imgToResize, Size size)
    {
        int sourceWidth = imgToResize.Width;
        int sourceHeight = imgToResize.Height;

        float nPercent = 0;
        float nPercentW = 0;
        float nPercentH = 0;

        nPercentW = ((float)size.Width / (float)sourceWidth);
        nPercentH = ((float)size.Height / (float)sourceHeight);

        if (nPercentH < nPercentW)
            nPercent = nPercentH;
        else
            nPercent = nPercentW;

        int destWidth = (int)(sourceWidth * nPercent);
        int destHeight = (int)(sourceHeight * nPercent);

        Bitmap b = new Bitmap(destWidth, destHeight);
        Graphics g = Graphics.FromImage((System.Drawing.Image)b);
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;

        g.DrawImage(imgToResize, 0, 0, destWidth, destHeight);
        g.Dispose();
        GC.Collect();
        return (System.Drawing.Image)b;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}