using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GymApp.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class FixProgressEntry : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Clients_UserId",
                table: "Clients");

            migrationBuilder.AddUniqueConstraint(
                name: "AK_Clients_UserId",
                table: "Clients",
                column: "UserId");

            migrationBuilder.CreateTable(
                name: "ProgressEntries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    Weight = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    BodyFatPercentage = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Chest = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Waist = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EntryDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProgressEntries", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProgressEntries_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProgressEntries_ClientId",
                table: "ProgressEntries",
                column: "ClientId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ProgressEntries");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_Clients_UserId",
                table: "Clients");

            migrationBuilder.CreateIndex(
                name: "IX_Clients_UserId",
                table: "Clients",
                column: "UserId",
                unique: true);
        }
    }
}
