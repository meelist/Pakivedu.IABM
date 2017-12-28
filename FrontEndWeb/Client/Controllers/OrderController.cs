using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Client.Controllers
{
  public class OrderController : Controller
  {
    public ActionResult Sender()
    {
      return View();
    }

    public ActionResult Receiver()
    {
      return View();
    }

    public ActionResult Package()
    {
      return View();
    }

    public ActionResult Summary()
    {
      return View();
    }

    public ActionResult Process()
    {
      return View();
    }
  }
}