namespace ir_graphic
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripButton_GetNewGraphic = new System.Windows.Forms.ToolStripButton();
            this.toolStripLabel_MessageForUser = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripLabel_LogicLevel = new System.Windows.Forms.ToolStripLabel();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButton_GetNewGraphic,
            this.toolStripLabel_MessageForUser,
            this.toolStripSeparator1,
            this.toolStripLabel_LogicLevel});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(784, 25);
            this.toolStrip1.TabIndex = 0;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // toolStripButton_GetNewGraphic
            // 
            this.toolStripButton_GetNewGraphic.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton_GetNewGraphic.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton_GetNewGraphic.Image")));
            this.toolStripButton_GetNewGraphic.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton_GetNewGraphic.Name = "toolStripButton_GetNewGraphic";
            this.toolStripButton_GetNewGraphic.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton_GetNewGraphic.Text = "toolStripButton1";
            this.toolStripButton_GetNewGraphic.Click += new System.EventHandler(this.toolStripButton_GetNewGraphic_Click);
            // 
            // toolStripLabel_MessageForUser
            // 
            this.toolStripLabel_MessageForUser.Name = "toolStripLabel_MessageForUser";
            this.toolStripLabel_MessageForUser.Size = new System.Drawing.Size(270, 22);
            this.toolStripLabel_MessageForUser.Text = "<- Для получения графика нажмите эту кнопку";
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripLabel_LogicLevel
            // 
            this.toolStripLabel_LogicLevel.Name = "toolStripLabel_LogicLevel";
            this.toolStripLabel_LogicLevel.Size = new System.Drawing.Size(21, 22);
            this.toolStripLabel_LogicLevel.Text = "[1]";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(784, 562);
            this.Controls.Add(this.toolStrip1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton toolStripButton_GetNewGraphic;
        private System.Windows.Forms.ToolStripLabel toolStripLabel_MessageForUser;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripLabel toolStripLabel_LogicLevel;
    }
}

