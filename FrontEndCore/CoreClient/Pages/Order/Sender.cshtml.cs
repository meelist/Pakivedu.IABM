using System.Threading.Tasks;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class SenderModel : PageModel
  {
    [BindProperty]
    public Customer Sender { get; set; }

    public void OnGet()
    {
      Sender = new Customer();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      var senderJson = JsonConvert.SerializeObject(Sender);
      TempData["Sender"] = senderJson;
      return RedirectToPage("/Order/Receiver");
    }
  }
}