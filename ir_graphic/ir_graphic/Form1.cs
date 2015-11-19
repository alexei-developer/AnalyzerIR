using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;



namespace ir_graphic
{
    //[System.Runtime.InteropServices.DllImport("ftd2xx.dll")]
    //public static extern int FT_Open();

    public partial class Form1 : Form
    {
        private string[] ir_codes;
        private uint count_graphics = 0;

        private Pen pen_generate_graphics = new Pen(Color.DarkGreen, 1);
        private Point point_generate_graphics = new Point(0, 20);

        Point[] points_cur_graphic;

        public Form1()
        {
            InitializeComponent();
            
            ir_codes = System.IO.File.ReadAllLines("file.type");
            Array.Reverse(ir_codes);
            
            point_generate_graphics.Y += toolStrip1.Height;

            points_cur_graphic = new Point[(int)ir_codes.Length/3 + 1];

            points_cur_graphic[0].X = point_generate_graphics.X;
            points_cur_graphic[0].Y = point_generate_graphics.Y;

            for (int i = 0; i < ir_codes.Length; i++)
            {
                if (((i - 1) % 3) == 0 && (i + 1) < ir_codes.Length)
                {
                    int logic_level = int.Parse(ir_codes[i+1]);
                    points_cur_graphic[i/3 + 1].Y = (logic_level < 128) ? point_generate_graphics.Y + 10 : point_generate_graphics.Y - 10;
                    points_cur_graphic[i/3 + 1].X = points_cur_graphic[i/3].X + int.Parse(ir_codes[i]) / 5;
                }
            }
        }
        
        private void toolStripButton_GetNewGraphic_Click(object sender, EventArgs e)
        {
            ir_codes = System.IO.File.ReadAllLines("file.type");
            Array.Reverse(ir_codes);
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            if (point_generate_graphics.Y + 10 > e.ClipRectangle.Y)
            {
                Graphics g = e.Graphics;//this.CreateGraphics();

                for (int i = 0; i < points_cur_graphic.Length - 1; i++)
                {

                    g.DrawLine(pen_generate_graphics, points_cur_graphic[i].X, points_cur_graphic[i + 1].Y, points_cur_graphic[i + 1].X, points_cur_graphic[i + 1].Y);
                    g.DrawLine(pen_generate_graphics, points_cur_graphic[i + 1].X, points_cur_graphic[i].Y, points_cur_graphic[i + 1].X, points_cur_graphic[i + 1].Y);
                }
            }
         
        }
    }
}
