using System.Threading.Tasks;
using CoreClient.Extensions;
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
      Sender = TempData.GetWithKeep<Customer>("Sender") ?? new Customer();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      TempData.Put("Sender", Sender);
      return RedirectToPage("/Order/Receiver");
    }
  }
}