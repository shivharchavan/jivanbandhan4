<%@ Page Title="My Profile - JivanBandhan Matrimony" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="MyProfile.aspx.cs" Inherits="JivanBandhan4.MyProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /* Modern Color Scheme */
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --accent: #d63384;
            --success: #48c78e;
            --warning: #feca57;
            --danger: #ff6b6b;
            --light: #f8f9fa;
            --dark: #343a40;
            --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .profile-container {
            background: white;
            border-radius: 25px;
            padding: 30px;
            margin: 20px 0;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .profile-header h1 {
            font-size: 3rem;
            margin-bottom: 15px;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .profile-content {
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }

        .profile-left {
            flex: 1;
            min-width: 350px;
        }

        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            text-align: center;
            margin-bottom: 30px;
            border: 1px solid rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        .profile-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 8px;
            background: var(--gradient);
        }

        .profile-photo-main {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 6px solid white;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .profile-basic-info h2 {
            color: var(--dark);
            font-size: 2rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .profile-stats {
            display: flex;
            justify-content: space-around;
            margin: 25px 0;
            padding: 20px 0;
            border-top: 2px solid var(--light);
            border-bottom: 2px solid var(--light);
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            display: block;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
        }

        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Photo Gallery with Repeater */
        .photo-gallery {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .gallery-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid var(--light);
        }

        .gallery-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        .add-photo-btn {
            background: var(--gradient);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .gallery-item {
            position: relative;
            aspect-ratio: 1;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .gallery-item.empty {
            background: linear-gradient(135deg, var(--light), #e9ecef);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px dashed #dee2e6;
            cursor: pointer;
        }

        .empty-gallery-text {
            color: #6c757d;
            font-size: 2rem;
            opacity: 0.5;
        }

        .remove-photo-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            background: var(--danger);
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: all 0.3s ease;
        }

        .gallery-item:hover .remove-photo-btn {
            opacity: 1;
        }

        /* Profile Right Side */
        .profile-right {
            flex: 2;
            min-width: 500px;
        }

        .profile-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            border-left: 6px solid var(--primary);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid var(--light);
        }

        .section-title {
            color: var(--dark);
            font-size: 1.6rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .edit-section-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Info Grid with Repeater */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid var(--light);
            transition: all 0.3s ease;
        }

        .info-label {
            font-weight: 600;
            color: var(--dark);
            font-size: 1rem;
            min-width: 150px;
        }

        .info-value {
            color: #6c757d;
            text-align: right;
            flex: 1;
            font-size: 1rem;
        }

        .editable-field {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid var(--light);
        }

        .save-btn {
            background: var(--gradient);
            border: none;
            color: white;
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cancel-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        /* Success/Error Messages */
        .success-message {
            background: linear-gradient(135deg, var(--success), #257953);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
            animation: slideIn 0.5s ease-out;
        }

        .error-message {
            background: linear-gradient(135deg, var(--danger), #d63384);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Profile Completeness */
        .profile-completeness {
            background: var(--gradient);
            color: white;
            padding: 25px;
            border-radius: 20px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }

        .completeness-bar {
            background: rgba(255,255,255,0.2);
            border-radius: 15px;
            height: 12px;
            margin: 20px 0;
            overflow: hidden;
        }

        .completeness-fill {
            background: linear-gradient(90deg, var(--success), #74d7a5);
            height: 100%;
            border-radius: 15px;
            transition: width 1s ease-in-out;
        }

        /* Modal Styles */
        .photo-upload-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 20px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 25px 80px rgba(0,0,0,0.3);
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 2rem;
            color: #6c757d;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .profile-content {
                flex-direction: column;
            }
            .profile-left, .profile-right {
                min-width: 100%;
            }
            .gallery-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>


     <div class="container mt-4">
    <h1><asp:Literal ID="litPageTitle" runat="server" Text="Welcome to JivanBandhan"></asp:Literal></h1>
    <p><asp:Literal ID="litPageDescription" runat="server" Text="Find your perfect life partner..."></asp:Literal></p>
    
    <!-- Dynamic content साठी Literal controls वापरा -->
</div>


    <!-- Photo Upload Modal -->
    <div id="photoUploadModal" class="photo-upload-modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closePhotoModal()">&times;</span>
            <h3 style="margin-bottom: 20px; color: var(--dark);">📸 Upload New Photo</h3>
            
            <div class="file-upload-area" style="border: 3px dashed #dee2e6; border-radius: 15px; padding: 40px; text-align: center; margin-bottom: 20px; cursor: pointer;" 
                 onclick="document.getElementById('<%= fuNewPhoto.ClientID %>').click()">
                <i class="fas fa-cloud-upload-alt" style="font-size: 3rem; color: #6c757d; margin-bottom: 15px;"></i>
                <p style="color: #6c757d; margin-bottom: 10px;">Click to select a photo</p>
                <small style="color: #8c94a0;">JPG, PNG files up to 5MB</small>
            </div>
            
            <asp:FileUpload ID="fuNewPhoto" runat="server" style="display: none;" accept=".jpg,.jpeg,.jpg" onchange="previewNewPhoto(this)" />
            
            <div id="newPhotoPreview" style="display: none; text-align: center; margin: 20px 0;">
                <img id="newPreviewImg" style="max-width: 200px; max-height: 200px; border-radius: 15px;" />
            </div>
            
            <div style="margin-bottom: 15px;">
                <asp:CheckBox ID="cbSetAsProfile" runat="server" Text=" Set as Profile Photo" />
            </div>
            
            <div class="action-buttons">
                <button type="button" class="cancel-btn" onclick="closePhotoModal()">Cancel</button>
                <asp:Button ID="btnUploadNewPhoto" runat="server" CssClass="save-btn" Text="Upload Photo" OnClick="btnUploadNewPhoto_Click" />
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <div class="profile-container">
            <div class="profile-header">
                <h1>🌟 My Profile</h1>
                <p>Manage your profile information and photos</p>
            </div>

            <!-- Profile Completeness -->
            <div class="profile-completeness">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <div style="font-size: 1.4rem; font-weight: 600;">Profile Completeness</div>
                    <div style="font-size: 2rem; font-weight: 700; background: linear-gradient(45deg, #fff, #f8f9fa); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        <asp:Literal ID="ltCompleteness" runat="server" Text="75%"></asp:Literal>
                    </div>
                </div>
                <div class="completeness-bar">
                    <div class="completeness-fill" id="completenessFill" runat="server" style="width: 75%"></div>
                </div>
                <div style="font-size: 1rem; opacity: 0.9;">
                    <asp:Literal ID="ltCompletenessMessage" runat="server" Text="Complete your profile to get better matches"></asp:Literal>
                </div>
            </div>

            <!-- Messages -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="success-message">
                <asp:Literal ID="ltMessage" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="profile-content">
                <!-- Left Side -->
                <div class="profile-left">
                    <!-- Profile Card -->
                    <div class="profile-card">
                        <asp:Image ID="imgProfile" runat="server" CssClass="profile-photo-main" 
                            ImageUrl="~/Images/default-profile.jpg" AlternateText="Profile Photo" />
                        
                        <div class="profile-basic-info">
                            <h2><asp:Literal ID="ltFullName" runat="server" Text="Your Name"></asp:Literal></h2>
                            <div style="color: var(--primary); font-size: 1.3rem; font-weight: 600; margin-bottom: 8px;">
                                <asp:Literal ID="ltAgeOccupation" runat="server" Text="Age | Occupation"></asp:Literal>
                            </div>
                            <div style="color: #6c757d; font-size: 1.1rem;">
                                <i class="fas fa-map-marker-alt"></i>
                                <asp:Literal ID="ltLocation" runat="server" Text="City, State"></asp:Literal>
                            </div>
                        </div>

                        <div class="profile-stats">
                            <div class="stat-item">
                                <span class="stat-value">
                                    <asp:Literal ID="ltStatAge" runat="server" Text="25"></asp:Literal>
                                </span>
                                <span class="stat-label">Age</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">
                                    <asp:Literal ID="ltStatHeight" runat="server" Text="5'8&quot;"></asp:Literal>
                                </span>
                                <span class="stat-label">Height</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">
                                    <asp:Literal ID="ltStatPhotos" runat="server" Text="3"></asp:Literal>
                                </span>
                                <span class="stat-label">Photos</span>
                            </div>
                        </div>

                        <div style="margin-top: 20px;">
                            <span class="badge badge-primary">
                                <asp:Literal ID="ltBadgeReligion" runat="server" Text="Hindu"></asp:Literal>
                            </span>
                            <span class="badge badge-success">
                                <asp:Literal ID="ltBadgeCaste" runat="server" Text="Maratha"></asp:Literal>
                            </span>
                            <span class="badge badge-warning">
                                <asp:Literal ID="ltBadgeEducation" runat="server" Text="B.E."></asp:Literal>
                            </span>
                        </div>
                    </div>

                    <!-- Photo Gallery with Repeater -->
                    <div class="photo-gallery">
                        <div class="gallery-header">
                            <h3 class="gallery-title">📸 Photo Gallery</h3>
                            <button type="button" class="add-photo-btn" onclick="openPhotoModal()">
                                <i class="fas fa-plus"></i> Add Photo
                            </button>
                        </div>
                        
                        <div class="gallery-grid">
                            <!-- Photos Repeater -->
                            <asp:Repeater ID="rptPhotos" runat="server" OnItemCommand="rptPhotos_ItemCommand">
                                <ItemTemplate>
                                    <div class="gallery-item">
                                        <img src='<%# GetPhotoUrl(Eval("PhotoPath").ToString()) %>' 
                                             alt='Profile photo' 
                                             onerror="this.src='Images/default-profile.jpg'" />
                                        <asp:LinkButton ID="btnRemovePhoto" runat="server" 
                                            CssClass="remove-photo-btn"
                                            CommandName="RemovePhoto"
                                            CommandArgument='<%# Eval("PhotoID") %>'
                                            OnClientClick="return confirm('Are you sure you want to remove this photo?');">
                                            <i class="fas fa-times"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            
                            <!-- Empty Slots -->
                            <asp:Repeater ID="rptEmptySlots" runat="server">
                                <ItemTemplate>
                                    <div class="gallery-item empty" onclick="openPhotoModal()">
                                        <div class="empty-gallery-text">+</div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Profile Sections with Repeaters -->
                <div class="profile-right">
                    <!-- Personal Information -->
                    <div class="profile-section">
                        <div class="section-header">
                            <h3 class="section-title">
                                <span class="section-icon">👤</span>
                                Personal Information
                            </h3>
                            <asp:Button ID="btnEditPersonal" runat="server" CssClass="edit-section-btn" 
                                Text="✏️ Edit" OnClick="btnEditPersonal_Click" />
                        </div>
                        
                        <asp:Panel ID="pnlPersonalView" runat="server">
                            <div class="info-grid">
                                <asp:Repeater ID="rptPersonalInfo" runat="server">
                                    <ItemTemplate>
                                        <div class="info-item">
                                            <span class="info-label"><%# Eval("Label") %></span>
                                            <span class="info-value"><%# Eval("Value") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlPersonalEdit" runat="server" Visible="false">
                            <div class="info-grid">
                                <!-- Personal Info Fields -->
                                <div class="info-item">
                                    <span class="info-label">Full Name</span>
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="editable-field" placeholder="Enter full name"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Email</span>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="editable-field" TextMode="Email" placeholder="Enter email"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Mobile</span>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="editable-field" placeholder="Enter mobile number"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Date of Birth</span>
                                    <asp:TextBox ID="txtDOB" runat="server" CssClass="editable-field" TextMode="Date"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Gender</span>
                                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Gender</asp:ListItem>
                                        <asp:ListItem Value="Male">Male</asp:ListItem>
                                        <asp:ListItem Value="Female">Female</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Height</span>
                                    <asp:DropDownList ID="ddlHeight" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Height</asp:ListItem>
                                        <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                                        <asp:ListItem Value="5'1&quot;">5'1"</asp:ListItem>
                                        <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                                        <asp:ListItem Value="5'3&quot;">5'3"</asp:ListItem>
                                        <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                                        <asp:ListItem Value="5'5&quot;">5'5"</asp:ListItem>
                                        <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                                        <asp:ListItem Value="5'7&quot;">5'7"</asp:ListItem>
                                        <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                                        <asp:ListItem Value="5'9&quot;">5'9"</asp:ListItem>
                                        <asp:ListItem Value="5'10&quot;">5'10"</asp:ListItem>
                                        <asp:ListItem Value="5'11&quot;">5'11"</asp:ListItem>
                                        <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <asp:Button ID="btnCancelPersonal" runat="server" CssClass="cancel-btn" Text="❌ Cancel" OnClick="btnCancelPersonal_Click" />
                                <asp:Button ID="btnSavePersonal" runat="server" CssClass="save-btn" Text="💾 Save Changes" OnClick="btnSavePersonal_Click" />
                            </div>
                        </asp:Panel>
                    </div>

                    <!-- Professional Information -->
                    <div class="profile-section">
                        <div class="section-header">
                            <h3 class="section-title">
                                <span class="section-icon">💼</span>
                                Professional Information
                            </h3>
                            <asp:Button ID="btnEditProfessional" runat="server" CssClass="edit-section-btn" 
                                Text="✏️ Edit" OnClick="btnEditProfessional_Click" />
                        </div>
                        
                        <asp:Panel ID="pnlProfessionalView" runat="server">
                            <div class="info-grid">
                                <asp:Repeater ID="rptProfessionalInfo" runat="server">
                                    <ItemTemplate>
                                        <div class="info-item">
                                            <span class="info-label"><%# Eval("Label") %></span>
                                            <span class="info-value"><%# Eval("Value") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlProfessionalEdit" runat="server" Visible="false">
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Education</span>
                                    <asp:DropDownList ID="ddlEducation" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Education</asp:ListItem>
                                        <asp:ListItem Value="10th">10th Grade</asp:ListItem>
                                        <asp:ListItem Value="12th">12th Grade</asp:ListItem>
                                        <asp:ListItem Value="B.A.">B.A.</asp:ListItem>
                                        <asp:ListItem Value="B.Com">B.Com</asp:ListItem>
                                        <asp:ListItem Value="B.Sc">B.Sc</asp:ListItem>
                                        <asp:ListItem Value="B.E.">B.E.</asp:ListItem>
                                        <asp:ListItem Value="M.B.A.">M.B.A.</asp:ListItem>
                                        <asp:ListItem Value="M.A.">M.A.</asp:ListItem>
                                        <asp:ListItem Value="M.Sc">M.Sc</asp:ListItem>
                                        <asp:ListItem Value="C.A.">C.A.</asp:ListItem>
                                        <asp:ListItem Value="Ph.D.">Ph.D.</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Occupation</span>
                                    <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Occupation</asp:ListItem>
                                        <asp:ListItem Value="Student">Student</asp:ListItem>
                                        <asp:ListItem Value="Job">Job</asp:ListItem>
                                        <asp:ListItem Value="Business">Business</asp:ListItem>
                                        <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                                        <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                                        <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                                        <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                                        <asp:ListItem Value="Private Job">Private Job</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Company</span>
                                    <asp:TextBox ID="txtCompany" runat="server" CssClass="editable-field" placeholder="Enter company name"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Annual Income</span>
                                    <asp:DropDownList ID="ddlIncome" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Income</asp:ListItem>
                                        <asp:ListItem Value="0">None</asp:ListItem>
                                        <asp:ListItem Value="100000">Less than 1 Lakh</asp:ListItem>
                                        <asp:ListItem Value="200000">1-2 Lakhs</asp:ListItem>
                                        <asp:ListItem Value="500000">2-5 Lakhs</asp:ListItem>
                                        <asp:ListItem Value="1000000">5-10 Lakhs</asp:ListItem>
                                        <asp:ListItem Value="2000000">10-20 Lakhs</asp:ListItem>
                                        <asp:ListItem Value="5000000">More than 20 Lakhs</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <asp:Button ID="btnCancelProfessional" runat="server" CssClass="cancel-btn" Text="❌ Cancel" OnClick="btnCancelProfessional_Click" />
                                <asp:Button ID="btnSaveProfessional" runat="server" CssClass="save-btn" Text="💾 Save Changes" OnClick="btnSaveProfessional_Click" />
                            </div>
                        </asp:Panel>
                    </div>

                    <!-- Additional Information -->
                    <div class="profile-section">
                        <div class="section-header">
                            <h3 class="section-title">
                                <span class="section-icon">📋</span>
                                Additional Information
                            </h3>
                            <asp:Button ID="btnEditAdditional" runat="server" CssClass="edit-section-btn" 
                                Text="✏️ Edit" OnClick="btnEditAdditional_Click" />
                        </div>
                        
                        <asp:Panel ID="pnlAdditionalView" runat="server">
                            <div class="info-grid">
                                <asp:Repeater ID="rptAdditionalInfo" runat="server">
                                    <ItemTemplate>
                                        <div class="info-item">
                                            <span class="info-label"><%# Eval("Label") %></span>
                                            <span class="info-value"><%# Eval("Value") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlAdditionalEdit" runat="server" Visible="false">
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Marital Status</span>
                                    <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Marital Status</asp:ListItem>
                                        <asp:ListItem Value="Never Married">Never Married</asp:ListItem>
                                        <asp:ListItem Value="Divorced">Divorced</asp:ListItem>
                                        <asp:ListItem Value="Widowed">Widowed</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Religion</span>
                                    <asp:DropDownList ID="ddlReligion" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Religion</asp:ListItem>
                                        <asp:ListItem Value="Hindu">Hindu</asp:ListItem>
                                        <asp:ListItem Value="Buddhist">Buddhist</asp:ListItem>
                                        <asp:ListItem Value="Christian">Christian</asp:ListItem>
                                        <asp:ListItem Value="Muslim">Muslim</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Caste</span>
                                    <asp:TextBox ID="txtCaste" runat="server" CssClass="editable-field" placeholder="Enter caste"></asp:TextBox>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Mother Tongue</span>
                                    <asp:DropDownList ID="ddlMotherTongue" runat="server" CssClass="editable-field">
                                        <asp:ListItem Value="">Select Mother Tongue</asp:ListItem>
                                        <asp:ListItem Value="Marathi">Marathi</asp:ListItem>
                                        <asp:ListItem Value="Hindi">Hindi</asp:ListItem>
                                        <asp:ListItem Value="English">English</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <asp:Button ID="btnCancelAdditional" runat="server" CssClass="cancel-btn" Text="❌ Cancel" OnClick="btnCancelAdditional_Click" />
                                <asp:Button ID="btnSaveAdditional" runat="server" CssClass="save-btn" Text="💾 Save Changes" OnClick="btnSaveAdditional_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openPhotoModal() {
            document.getElementById('photoUploadModal').style.display = 'block';
        }

        function closePhotoModal() {
            document.getElementById('photoUploadModal').style.display = 'none';
            document.getElementById('newPhotoPreview').style.display = 'none';
            document.getElementById('<%= fuNewPhoto.ClientID %>').value = '';
        }

        function previewNewPhoto(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('newPreviewImg').src = e.target.result;
                    document.getElementById('newPhotoPreview').style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            const modal = document.getElementById('photoUploadModal');
            if (event.target === modal) {
                closePhotoModal();
            }
        }
    </script>
</asp:Content>