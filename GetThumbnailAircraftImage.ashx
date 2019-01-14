<%@ WebHandler Language="C#" Class="GetThumbnailAircraftImage" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Drawing;
using System.IO;
using System.Web.SessionState;
public class GetThumbnailAircraftImage : IHttpHandler,IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("typephotothumb") != null)
        {
            
            Image i = Image.FromFile(context.Server.MapPath(@"images/" + context.Request.Params.Get("typeid") + ".jpeg"));
            i = i.GetThumbnailImage(65, 43, null, IntPtr.Zero);
            MemoryStream imageStream = new MemoryStream();
            i.Save(imageStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            byte[] imageContent = new Byte[imageStream.Length];
            imageStream.Position = 0;
            imageStream.Read(imageContent, 0, (int)imageStream.Length);
            context.Response.ContentType = "image/jpeg";
            context.Response.BinaryWrite(imageContent);
            imageStream.Dispose();
            imageStream.Close();
            i = null;
            GC.Collect();
        }
        else
        {

            AircraftPhoto p = OperatorDAO.FindAircraftPhotoByID(Int64.Parse(context.Request.Params.Get("pid")));
            if (File.Exists(context.Server.MapPath(@"aircraftphotos/" + p.PhotoID + ".jpeg")))
            {
                Image i = Image.FromFile(context.Server.MapPath(@"aircraftphotos/" + p.PhotoID + ".jpeg"));
                i = i.GetThumbnailImage(100, 100, null, IntPtr.Zero);
                MemoryStream imageStream = new MemoryStream();
                i.Save(imageStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                byte[] imageContent = new Byte[imageStream.Length];
                imageStream.Position = 0;
                imageStream.Read(imageContent, 0, (int)imageStream.Length);
                context.Response.ContentType = "image/jpeg";
                context.Response.BinaryWrite(imageContent);
                imageStream.Dispose();
                imageStream.Close();
                i = null;
                GC.Collect();
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