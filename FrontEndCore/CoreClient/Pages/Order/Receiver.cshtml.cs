using System;
using System.Threading.Tasks;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class ReceiverModel : PageModel
  {
    [BindProperty]
    public Customer Sender { get; set; }
    [BindProperty]
    public Customer Receiver { get; set; }

    public void OnGet()
    {
      Sender = JsonConvert.DeserializeObject<Customer>(TempData["Sender"] as string);
      Receiver = new Customer();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      var senderJson = JsonConvert.SerializeObject(Sender);
      TempData["Sender"] = senderJson;
      var receiverJson = JsonConvert.SerializeObject(Receiver);
      TempData["Receiver"] = receiverJson;
      return RedirectToPage("/Order/Package");
    }
  }
}