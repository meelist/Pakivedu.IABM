using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Client.Models;

namespace Client.Controllers
{
  public class HomeController : Controller
  {
    public ActionResult Index(LoginModel model)
    {
      var x = ModelState.Values;
      return View();
    }

    public ActionResult Login(LoginModel model)
    {
      return View(model);
    }

    public ActionResult Register()
    {
      return View();
    }

    public ActionResult Order()
    {
      return View();
    }

    public ActionResult Status()
    {
      return View();
    }

    public ActionResult Statistics()
    {
      return View();
    }

    public ActionResult ManageProfile()
    {
      return View();
    }
  }
}