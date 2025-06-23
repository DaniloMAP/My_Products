using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using ProductApi.Models;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

var products = Enumerable.Range(1, 50)
    .Select(i => new Product {
        Id       = i,
        Name     = $"Produto {i}",
        Price    = 10 + i,
        ImageUrl = $"https://picsum.photos/seed/prod{i}/300/300"
    })
    .ToList();

app.Use(async (ctx, next) =>
{
    var key = ctx.Request.Headers["X-Api-Key"].ToString();
    const string expectedKey = "MINHA_CHAVE_SECRETA";
    if (string.IsNullOrEmpty(key) || key != expectedKey)
    {
        ctx.Response.StatusCode = StatusCodes.Status401Unauthorized;
        await ctx.Response.WriteAsync("Unauthorized");
        return;
    }
    await next();
});

// GET
app.MapGet("/api/products", (int page = 1, int pageSize = 10, string? search = null) =>
{
    var filteredProducts = products.AsQueryable();
    
    if (!string.IsNullOrWhiteSpace(search))
    {
        filteredProducts = filteredProducts.Where(p => 
            p.Name.Contains(search, StringComparison.OrdinalIgnoreCase));
    }
    
    var total = filteredProducts.Count();
    var items = filteredProducts
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .ToList();

    return Results.Ok(new
    {
        page,
        pageSize,
        totalCount = total,
        items,
        searchTerm = search
    });
})
.WithName("GetProducts")
.WithTags("Products");

app.Run();
