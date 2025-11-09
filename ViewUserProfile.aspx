<%@ Page Title="Marathi Matrimony - View Profile" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="ViewUserProfile.aspx.cs" Inherits="JivanBandhan4.ViewUserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .profile-view-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #eef2ff 50%, #f0f4ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .profile-view-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            clip-path: polygon(0 0, 100% 0, 100% 70%, 0 100%);
            z-index: 0;
        }
        
        .profile-header-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            color: #2c3e50;
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1;
        }
        
        .profile-main-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .profile-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .profile-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 35px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .user-photo-extra-large {
            width: 280px;
            height: 280px;
            border-radius: 20px;
            object-fit: cover;
            border: 8px solid rgba(255,255,255,0.9);
            margin: 0 auto 25px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
            cursor: pointer;
        }
        
        .profile-name-large {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .profile-basic-info {
            background: rgba(248,249,250,0.7);
            padding: 20px;
            border-radius: 20px;
            margin: 20px 0;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
            text-align: right;
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin: 30px 0 20px 0;
            font-size: 1.5rem;
            font-weight: bold;
            position: relative;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 20px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        
        .btn-profile-action {
            padding: 15px 25px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-width: 160px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        /* Block & Report Button Styles for View Profile */
        .btn-block {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .btn-report {
            background: linear-gradient(135deg, #fd7e14 0%, #e55a00 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(253, 126, 20, 0.4);
        }

        .block-report-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid rgba(0,0,0,0.1);
        }

        .btn-block-report-large {
            padding: 12px 20px;
            border: none;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-bottom: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-block-report-large:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .online-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .online {
            background: rgba(81, 207, 102, 0.2);
            color: #2d8a3e;
            border: 1px solid rgba(81, 207, 102, 0.3);
        }
        
        .offline {
            background: rgba(108, 117, 125, 0.2);
            color: #495057;
            border: 1px solid rgba(108, 117, 125, 0.3);
        }
        
        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }
        
        .online .status-dot {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        .offline .status-dot {
            background: #6c757d;
        }

        /* Photo Gallery Styles */
        .photo-gallery-section {
            margin: 30px 0;
        }

        .gallery-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%) 1;
            padding-bottom: 12px;
            margin: 25px 0 15px 0;
            font-size: 1.3rem;
            font-weight: bold;
        }

        .photo-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border: 3px solid transparent;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }

        .gallery-item:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            border-color: rgba(102, 126, 234, 0.5);
        }

        .gallery-photo {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 12px;
            transition: all 0.4s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
        }

        .gallery-item:hover .gallery-photo {
            transform: scale(1.1);
        }

        .photo-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            padding: 10px;
            color: white;
            font-size: 0.8rem;
            opacity: 0;
            transition: all 0.3s ease;
            transform: translateY(10px);
        }

        .gallery-item:hover .photo-overlay {
            opacity: 1;
            transform: translateY(0);
        }

        /* Fullscreen Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.95);
            backdrop-filter: blur(10px);
        }

        .modal-content {
            position: relative;
            margin: auto;
            display: block;
            width: auto;
            max-width: 90%;
            max-height: 90%;
            top: 50%;
            transform: translateY(-50%);
            border-radius: 15px;
            box-shadow: 0 25px 80px rgba(0,0,0,0.5);
            animation: zoomIn 0.3s ease;
        }

        @keyframes zoomIn {
            from { transform: translateY(-50%) scale(0.7); opacity: 0; }
            to { transform: translateY(-50%) scale(1); opacity: 1; }
        }

        .close-modal {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10001;
            background: rgba(0,0,0,0.5);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .close-modal:hover {
            background: rgba(220, 53, 69, 0.8);
            transform: scale(1.1);
        }

        .modal-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            font-size: 24px;
            padding: 15px;
            cursor: pointer;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .modal-nav:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-50%) scale(1.1);
        }

        .prev-nav {
            left: 20px;
        }

        .next-nav {
            right: 20px;
        }

        .modal-counter {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            background: rgba(0,0,0,0.5);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            backdrop-filter: blur(10px);
        }

        .no-photos-message {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
            background: rgba(248,249,250,0.7);
            border-radius: 15px;
            border: 2px dashed #dee2e6;
        }

        .no-photos-message i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #adb5bd;
        }

        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }

        @media (max-width: 992px) {
            .profile-main-layout {
                grid-template-columns: 1fr;
            }
            
            .user-photo-extra-large {
                width: 220px;
                height: 220px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-profile-action {
                width: 100%;
                max-width: 300px;
            }
            
            .photo-gallery {
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .profile-header-banner {
                padding: 20px;
            }
            
            .profile-content {
                padding: 25px;
            }
            
            .profile-sidebar {
                padding: 20px;
            }
            
            .user-photo-extra-large {
                width: 200px;
                height: 200px;
            }
            
            .profile-name-large {
                font-size: 1.7rem;
            }
            
            .modal-content {
                max-width: 95%;
                max-height: 80%;
            }
            
            .modal-nav {
                width: 40px;
                height: 40px;
                font-size: 20px;
            }
            
            .close-modal {
                font-size: 30px;
                width: 40px;
                height: 40px;
            }
        }
    </style>

    <div class="profile-view-container">
        <div class="container">
            <!-- Profile Header -->
            <div class="profile-header-banner">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">Profile Details</h1>
                        <p class="marathi-font mb-0">Complete profile information</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBack" runat="server" Text="⬅ Back to Dashboard" 
                            CssClass="btn btn-secondary marathi-font" OnClick="btnBack_Click" />
                    </div>
                </div>
            </div>

            <!-- Main Profile Layout -->
            <div class="profile-main-layout">
                <!-- Left Sidebar -->
                <div class="profile-sidebar">
                    <!-- Large Profile Photo -->
                    <asp:Image ID="imgProfileLarge" runat="server" CssClass="user-photo-extra-large" 
                        ImageUrl="~/Images/default-profile.jpg" 
                        onerror="this.src='Images/default-profile.jpg'"
                        onclick="openModal(0)" />
                    
                    <!-- Online Status -->
                    <div class="online-status marathi-font" id="onlineStatus" runat="server">
                        <div class="status-dot"></div>
                        <span id="statusText" runat="server">Online</span>
                    </div>
                    
                    <div class="profile-name-large marathi-font">
                        <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label>
                    </div>
                    
                    <!-- Basic Information -->
                    <div class="profile-basic-info">
                        <div class="info-item marathi-font">
                            <span class="info-label">Profile ID:</span>
                            <span class="info-value">
                                <asp:Label ID="lblProfileID" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Age:</span>
                            <span class="info-value">
                                <asp:Label ID="lblAge" runat="server" Text=""></asp:Label> Years
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Height:</span>
                            <span class="info-value">
                                <asp:Label ID="lblHeight" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Religion:</span>
                            <span class="info-value">
                                <asp:Label ID="lblReligion" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Caste:</span>
                            <span class="info-value">
                                <asp:Label ID="lblCaste" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Location:</span>
                            <span class="info-value">
                                <asp:Label ID="lblLocation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Occupation:</span>
                            <span class="info-value">
                                <asp:Label ID="lblOccupation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Education:</span>
                            <span class="info-value">
                                <asp:Label ID="lblEducation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Marital Status:</span>
                            <span class="info-value">
                                <asp:Label ID="lblMaritalStatus" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <asp:Button ID="btnSendInterest" runat="server" Text="💝 Send Interest" 
                            CssClass="btn-profile-action btn-interest marathi-font" OnClientClick="sendInterest(); return false;" />
                        <asp:Button ID="btnSendMessage" runat="server" Text="💌 Send Message" 
                            CssClass="btn-profile-action btn-message marathi-font" OnClientClick="sendMessage(); return false;" />
                        <asp:Button ID="btnShortlist" runat="server" Text="⭐ Shortlist" 
                            CssClass="btn-profile-action btn-shortlist marathi-font" OnClientClick="shortlistProfile(); return false;" />
                    </div>

                    <!-- Block & Report Section -->
                    <div class="block-report-section">
                        <h5 class="marathi-font text-center mb-3">Safety & Privacy</h5>
                        <button class="btn-block-report-large btn-block marathi-font" 
                            onclick='blockUser()'>
                            🚫 Block User
                        </button>
                        <button class="btn-block-report-large btn-report marathi-font" 
                            onclick='reportUser()'>
                            ⚠ Report Profile
                        </button>
                    </div>
                </div>
                
                <!-- Right Content -->
                <div class="profile-content">
                    <!-- Photo Gallery Section -->
                    <div class="photo-gallery-section">
                        <h3 class="gallery-title marathi-font">
                            <i class="fas fa-images"></i> Photo Gallery
                        </h3>
                        
                        <div class="photo-gallery" id="photoGallery" runat="server">
                            <!-- Photos will be dynamically added here -->
                        </div>
                        
                        <asp:Panel ID="pnlNoPhotos" runat="server" CssClass="no-photos-message" Visible="false">
                            <i class="fas fa-camera"></i>
                            <h5 class="marathi-font">No Photos Available</h5>
                            <p class="marathi-font">This user hasn't uploaded any photos yet.</p>
                        </asp:Panel>
                    </div>

                    <!-- Personal Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-user"></i> Personal Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #d63384; margin-bottom: 15px;">
                                <i class="fas fa-info-circle"></i> Basic Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalFullName" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Gender:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblGender" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblDOB" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Marital Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalMaritalStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #667eea; margin-bottom: 15px;">
                                <i class="fas fa-heart"></i> Religious Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Religion:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalReligion" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Sub Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSubCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Manglik:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblManglik" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Education & Career -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-graduation-cap"></i> Education & Career
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #28a745; margin-bottom: 15px;">
                                <i class="fas fa-university"></i> Education
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Highest Education:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblHighestEducation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Education Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblEducationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">College/University:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCollege" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #ffc107; margin-bottom: 15px;">
                                <i class="fas fa-briefcase"></i> Career
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCareerOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblOccupationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Annual Income:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblAnnualIncome" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Family Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-home"></i> Family Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #dc3545; margin-bottom: 15px;">
                                <i class="fas fa-users"></i> Family Background
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Family Type:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFamilyType" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Father's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFatherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Mother's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblMotherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Fullscreen Photo Modal -->
    <div id="photoModal" class="modal">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <button class="modal-nav prev-nav" onclick="changePhoto(-1)">&#10094;</button>
        <button class="modal-nav next-nav" onclick="changePhoto(1)">&#10095;</button>
        <img class="modal-content" id="modalImage">
        <div class="modal-counter" id="modalCounter">1 / 1</div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnViewedUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnUserPhotos" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // Global variables for photo gallery
        let currentPhotoIndex = 0;
        let userPhotos = [];

        // Initialize photo gallery from hidden field
        function initializePhotoGallery() {
            const photosData = document.getElementById('<%= hdnUserPhotos.ClientID %>').value;
            if (photosData) {
                userPhotos = JSON.parse(photosData);
            }
        }

        // Open modal with specific photo
        function openModal(index) {
            if (userPhotos.length === 0) return;

            currentPhotoIndex = index;
            const modal = document.getElementById('photoModal');
            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            modal.style.display = 'block';
            modalImg.src = userPhotos[currentPhotoIndex].url;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;

            // Prevent body scroll
            document.body.style.overflow = 'hidden';
        }

        // Close modal
        function closeModal() {
            const modal = document.getElementById('photoModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Change photo in modal
        function changePhoto(direction) {
            currentPhotoIndex += direction;

            // Loop around
            if (currentPhotoIndex >= userPhotos.length) {
                currentPhotoIndex = 0;
            } else if (currentPhotoIndex < 0) {
                currentPhotoIndex = userPhotos.length - 1;
            }

            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            modalImg.src = userPhotos[currentPhotoIndex].url;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;
        }

        // Keyboard navigation
        document.addEventListener('keydown', function (event) {
            const modal = document.getElementById('photoModal');
            if (modal.style.display === 'block') {
                if (event.key === 'Escape') {
                    closeModal();
                } else if (event.key === 'ArrowLeft') {
                    changePhoto(-1);
                } else if (event.key === 'ArrowRight') {
                    changePhoto(1);
                }
            }
        });

        // Close modal when clicking outside image
        document.getElementById('photoModal').addEventListener('click', function (event) {
            if (event.target === this) {
                closeModal();
            }
        });

        // Send Interest Function
        function sendInterest() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send interest');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = document.getElementById('<%= btnSendInterest.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Interest sent successfully!', 'success');
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = '#ffc107';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        }

        // Send Message Function
        function sendMessage() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send message');
                return;
            }

            const message = prompt('Enter your message:');
            if (message) {
                const button = document.getElementById('<%= btnSendMessage.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: parseInt(viewedUserID),
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Message sent successfully!', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            }
        }

        // Shortlist Profile Function
        function shortlistProfile() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to shortlist profile');
                return;
            }

            const button = document.getElementById('<%= btnShortlist.ClientID %>');
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            $.ajax({
                type: "POST",
                url: "ViewUserProfile.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: parseInt(viewedUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function for View Profile
        function blockUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to block user');
                return;
            }

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they will not be able to contact you.')) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('User blocked successfully! Redirecting...', 'success');
                            setTimeout(() => {
                                window.location.href = 'Dashboard.aspx';
                            }, 2000);
                        } else if (response.d === "exists") {
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function for View Profile
        function reportUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to report profile');
                return;
            }

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: parseInt(viewedUserID),
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('Profile reported successfully! Our team will review this profile.', 'success');
                        } else {
                            showNotification('Error reporting profile!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error reporting profile!', 'error');
                    }
                });
            }
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, #dc3545, #c82333)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, #17a2b8, #138496)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize photo gallery
            initializePhotoGallery();

            // Set random online status (for demo)
            const onlineStatus = document.getElementById('<%= onlineStatus.ClientID %>');
            const statusText = document.getElementById('<%= statusText.ClientID %>');
            const isOnline = Math.random() > 0.5;

            if (onlineStatus && statusText) {
                if (isOnline) {
                    onlineStatus.className = 'online-status marathi-font online';
                    statusText.textContent = 'Online Now';
                } else {
                    onlineStatus.className = 'online-status marathi-font offline';
                    statusText.textContent = 'Offline';
                }
            }
        });
    </script>
</asp:Content>























<%--<%@ Page Title="Marathi Matrimony - View Profile" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="ViewUserProfile.aspx.cs" Inherits="JivanBandhan4.ViewUserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .profile-view-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #eef2ff 50%, #f0f4ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .profile-view-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            clip-path: polygon(0 0, 100% 0, 100% 70%, 0 100%);
            z-index: 0;
        }
        
        .profile-header-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            color: #2c3e50;
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1;
        }
        
        .profile-main-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .profile-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .profile-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 35px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .user-photo-extra-large {
            width: 280px;
            height: 280px;
            border-radius: 20px;
            object-fit: cover;
            border: 8px solid rgba(255,255,255,0.9);
            margin: 0 auto 25px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
            cursor: pointer;
        }
        
        .user-photo-extra-large:hover {
            transform: scale(1.05);
            border-color: #d63384;
            box-shadow: 0 30px 70px rgba(214, 51, 132, 0.4);
        }
        
        .profile-name-large {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .profile-basic-info {
            background: rgba(248,249,250,0.7);
            padding: 20px;
            border-radius: 20px;
            margin: 20px 0;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
            text-align: right;
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin: 30px 0 20px 0;
            font-size: 1.5rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 80px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 20px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        
        .btn-profile-action {
            padding: 15px 25px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-width: 160px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-profile-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-profile-action:hover::before {
            left: 100%;
        }
        
        .btn-interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }
        
        .btn-back {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }
        
        .btn-profile-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        
        .photo-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .gallery-item:hover {
            transform: translateY(-5px);
        }
        
        .gallery-photo {
            width: 100%;
            height: 150px;
            border-radius: 15px;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.8);
            transition: all 0.3s ease;
            cursor: pointer;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2px;
        }
        
        .gallery-photo:hover {
            transform: scale(1.1);
            border-color: #d63384;
            box-shadow: 0 10px 25px rgba(214, 51, 132, 0.4);
        }

        .photo-type-badge {
            position: absolute;
            bottom: 8px;
            left: 8px;
            background: linear-gradient(135deg, rgba(214, 51, 132, 0.9) 0%, rgba(255, 107, 107, 0.9) 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: bold;
            backdrop-filter: blur(5px);
        }
        
        .premium-badge-large {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 15px;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        .online-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .online {
            background: rgba(81, 207, 102, 0.2);
            color: #2d8a3e;
            border: 1px solid rgba(81, 207, 102, 0.3);
        }
        
        .offline {
            background: rgba(108, 117, 125, 0.2);
            color: #495057;
            border: 1px solid rgba(108, 117, 125, 0.3);
        }
        
        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            animation: pulse-online 2s infinite;
        }
        
        .online .status-dot {
            background: #51cf66;
        }
        
        .offline .status-dot {
            background: #6c757d;
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 25px 0;
        }
        
        .stat-box {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .stat-number {
            display: block;
            font-size: 1.8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }

        /* Fullscreen Image Viewer Styles */
        .fullscreen-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.95);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.3s ease;
        }

        .fullscreen-modal-content {
            position: relative;
            margin: auto;
            padding: 20px;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .fullscreen-image {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            animation: zoomIn 0.3s ease;
        }

        .fullscreen-modal-close {
            position: absolute;
            top: 20px;
            right: 35px;
            color: #fff;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10001;
            background: rgba(214, 51, 132, 0.8);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .fullscreen-modal-close:hover {
            background: rgba(214, 51, 132, 1);
            transform: scale(1.1);
        }

        .fullscreen-modal-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            color: white;
            font-size: 30px;
            cursor: pointer;
            background: rgba(102, 126, 234, 0.8);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            border: none;
        }

        .fullscreen-modal-nav:hover {
            background: rgba(102, 126, 234, 1);
            transform: translateY(-50%) scale(1.1);
        }

        .fullscreen-modal-prev {
            left: 30px;
        }

        .fullscreen-modal-next {
            right: 30px;
        }

        .fullscreen-modal-counter {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            font-size: 18px;
            background: rgba(0, 0, 0, 0.7);
            padding: 10px 20px;
            border-radius: 25px;
            font-family: 'Nirmala UI', sans-serif;
        }

        .fullscreen-image-info {
            position: absolute;
            bottom: 80px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            text-align: center;
            background: rgba(0, 0, 0, 0.7);
            padding: 10px 20px;
            border-radius: 10px;
            font-family: 'Nirmala UI', sans-serif;
            max-width: 80%;
        }

        .fullscreen-loading {
            color: white;
            font-size: 18px;
            text-align: center;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes zoomIn {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        @media (max-width: 1200px) {
            .profile-main-layout {
                grid-template-columns: 300px 1fr;
                gap: 25px;
            }
            
            .user-photo-extra-large {
                width: 240px;
                height: 240px;
            }
        }
        
        @media (max-width: 992px) {
            .profile-main-layout {
                grid-template-columns: 1fr;
            }
            
            .user-photo-extra-large {
                width: 220px;
                height: 220px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-profile-action {
                width: 100%;
                max-width: 300px;
            }
        }
        
        @media (max-width: 768px) {
            .profile-header-banner {
                padding: 20px;
            }
            
            .profile-content {
                padding: 25px;
            }
            
            .profile-sidebar {
                padding: 20px;
            }
            
            .user-photo-extra-large {
                width: 200px;
                height: 200px;
            }
            
            .profile-name-large {
                font-size: 1.7rem;
            }

            .fullscreen-modal-nav {
                width: 50px;
                height: 50px;
                font-size: 24px;
            }
            
            .fullscreen-modal-prev {
                left: 15px;
            }
            
            .fullscreen-modal-next {
                right: 15px;
            }
            
            .fullscreen-modal-close {
                top: 15px;
                right: 20px;
                width: 40px;
                height: 40px;
                font-size: 30px;
            }
            
            .fullscreen-image {
                max-width: 95%;
                max-height: 80%;
            }
            
            .fullscreen-modal-counter {
                bottom: 20px;
                font-size: 16px;
            }
            
            .fullscreen-image-info {
                bottom: 60px;
                font-size: 14px;
                max-width: 90%;
            }
        }
        
        @media (max-width: 576px) {
            .user-photo-extra-large {
                width: 180px;
                height: 180px;
            }
            
            .profile-name-large {
                font-size: 1.5rem;
            }
            
            .btn-profile-action {
                padding: 12px 20px;
                font-size: 0.9rem;
            }
            
            .photo-gallery {
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            }
            
            .gallery-photo {
                height: 120px;
            }

            .fullscreen-modal-nav {
                width: 40px;
                height: 40px;
                font-size: 20px;
            }
            
            .fullscreen-modal-prev {
                left: 10px;
            }
            
            .fullscreen-modal-next {
                right: 10px;
            }
            
            .photo-type-badge {
                font-size: 0.6rem;
                padding: 3px 6px;
            }
        }
    </style>

    <div class="profile-view-container">
        <div class="container">
            <!-- Profile Header -->
            <div class="profile-header-banner">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">Profile Details</h1>
                        <p class="marathi-font mb-0">Complete profile information</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBack" runat="server" Text="⬅ Back to Dashboard" 
                            CssClass="btn btn-secondary marathi-font" OnClick="btnBack_Click" />
                    </div>
                </div>
            </div>

            <!-- Main Profile Layout -->
            <div class="profile-main-layout">
                <!-- Left Sidebar - Profile Photo & Basic Info -->
                <div class="profile-sidebar">
                    <!-- Large Profile Photo -->
                    <asp:Image ID="imgProfileLarge" runat="server" CssClass="user-photo-extra-large" 
                        ImageUrl="~/Images/default-profile.jpg" 
                        onerror="this.src='Images/default-profile.jpg'" />
                    
                    <!-- Online Status -->
                    <div class="online-status marathi-font" id="onlineStatus" runat="server">
                        <div class="status-dot"></div>
                        <span id="statusText" runat="server">Online</span>
                    </div>
                    
                    <!-- Premium Badge -->
                    <asp:Panel ID="pnlPremiumBadge" runat="server" CssClass="premium-badge-large marathi-font" Visible="false">
                        ⭐ Premium Member
                    </asp:Panel>
                    
                    <div class="profile-name-large marathi-font">
                        <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label>
                    </div>
                    
                    <!-- Basic Information -->
                    <div class="profile-basic-info">
                        <div class="info-item marathi-font">
                            <span class="info-label">Profile ID:</span>
                            <span class="info-value">
                                <asp:Label ID="lblProfileID" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Age:</span>
                            <span class="info-value">
                                <asp:Label ID="lblAge" runat="server" Text=""></asp:Label> Years
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Height:</span>
                            <span class="info-value">
                                <asp:Label ID="lblHeight" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Religion:</span>
                            <span class="info-value">
                                <asp:Label ID="lblReligion" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Caste:</span>
                            <span class="info-value">
                                <asp:Label ID="lblCaste" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Location:</span>
                            <span class="info-value">
                                <asp:Label ID="lblLocation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Occupation:</span>
                            <span class="info-value">
                                <asp:Label ID="lblOccupation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Education:</span>
                            <span class="info-value">
                                <asp:Label ID="lblEducation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <asp:Button ID="btnSendInterest" runat="server" Text="💝 Send Interest" 
                            CssClass="btn-profile-action btn-interest marathi-font" OnClientClick="sendInterest(); return false;" />
                        <asp:Button ID="btnSendMessage" runat="server" Text="💌 Send Message" 
                            CssClass="btn-profile-action btn-message marathi-font" OnClientClick="sendMessage(); return false;" />
                        <asp:Button ID="btnShortlist" runat="server" Text="⭐ Shortlist" 
                            CssClass="btn-profile-action btn-shortlist marathi-font" OnClientClick="shortlistProfile(); return false;" />
                    </div>
                    
                    <!-- Quick Stats -->
                    <div class="quick-stats">
                        <div class="stat-box">
                            <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                            <span class="stat-label marathi-font">Profile Views</span>
                        </div>
                        <div class="stat-box">
                            <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                            <span class="stat-label marathi-font">Interests Received</span>
                        </div>
                    </div>
                </div>
                
                <!-- Right Content - Detailed Information -->
                <div class="profile-content">
                    <!-- Personal Information Section -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-user"></i> Personal Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #d63384; margin-bottom: 15px;">
                                <i class="fas fa-info-circle"></i> Basic Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalFullName" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Gender:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblGender" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblDOB" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Marital Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblMaritalStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Physical Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPhysicalStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #667eea; margin-bottom: 15px;">
                                <i class="fas fa-heart"></i> Religious Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Religion:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalReligion" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Sub Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSubCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Gothra:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblGothra" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Manglik:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblManglik" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Education & Career Section -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-graduation-cap"></i> Education & Career
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #28a745; margin-bottom: 15px;">
                                <i class="fas fa-university"></i> Education
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Highest Education:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblHighestEducation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Education Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblEducationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">College/University:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCollege" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #ffc107; margin-bottom: 15px;">
                                <i class="fas fa-briefcase"></i> Career
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCareerOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblOccupationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Company:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCompany" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Annual Income:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblAnnualIncome" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Family Information Section -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-home"></i> Family Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #dc3545; margin-bottom: 15px;">
                                <i class="fas fa-users"></i> Family Background
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Family Type:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFamilyType" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Family Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFamilyStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Father's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFatherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Mother's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblMotherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #6f42c1; margin-bottom: 15px;">
                                <i class="fas fa-user-friends"></i> Siblings
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Brothers:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblBrothers" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Sisters:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSisters" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Native Place:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblNativePlace" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Lifestyle & Preferences Section -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-heartbeat"></i> Lifestyle & Preferences
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #20c997; margin-bottom: 15px;">
                                <i class="fas fa-utensils"></i> Habits
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Eating Habits:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblEatingHabits" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Drinking Habits:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblDrinkingHabits" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Smoking Habits:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSmokingHabits" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #fd7e14; margin-bottom: 15px;">
                                <i class="fas fa-star"></i> Hobbies & Interests
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Hobbies:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblHobbies" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">About Me:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblAboutMe" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Photo Gallery Section -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-images"></i> Photo Gallery
                    </h3>
                    
                    <div class="photo-gallery">
                        <asp:Repeater ID="rptPhotoGallery" runat="server" OnItemDataBound="rptPhotoGallery_ItemDataBound">
                            <ItemTemplate>
                                <div class="gallery-item">
                                    <img src='<%# Eval("PhotoPath") %>' class="gallery-photo" 
                                        onerror="this.src='Images/default-profile.jpg'" 
                                        alt='<%# Eval("PhotoType") %>'
                                        data-index='<%# Container.ItemIndex %>' />
                                    <div class="photo-type-badge marathi-font">
                                        <asp:Label ID="lblPhotoType" runat="server" Text='<%# Eval("PhotoType") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="pnlNoPhotos" runat="server" Visible="false" CssClass="text-center w-100">
                            <div class="empty-state">
                                <i class="fas fa-camera fa-3x text-muted mb-3"></i>
                                <p class="marathi-font text-muted">No additional photos available</p>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Fullscreen Image Viewer Modal -->
    <div id="fullscreenModal" class="fullscreen-modal">
        <span class="fullscreen-modal-close">&times;</span>
        
        <button class="fullscreen-modal-nav fullscreen-modal-prev">&#10094;</button>
        <button class="fullscreen-modal-nav fullscreen-modal-next">&#10095;</button>
        
        <div class="fullscreen-modal-content">
            <div id="fullscreenLoading" class="fullscreen-loading" style="display: none;">
                <i class="fas fa-spinner fa-spin"></i> Loading...
            </div>
            <img id="fullscreenImage" class="fullscreen-image" src="" alt="Fullscreen Image" style="display: none;">
        </div>
        
        <div class="fullscreen-image-info" id="imageInfo"></div>
        <div class="fullscreen-modal-counter" id="imageCounter"></div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnViewedUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // Fullscreen Image Viewer Functionality
        let currentImageIndex = 0;
        let galleryImages = [];

        function initializeFullscreenViewer() {
            // Collect all gallery images including main profile photo
            const mainProfilePhoto = document.getElementById('<%= imgProfileLarge.ClientID %>');
            galleryImages = Array.from(document.querySelectorAll('.gallery-photo'));

            // Add main profile photo to the beginning of gallery if it exists
            if (mainProfilePhoto && mainProfilePhoto.src && !mainProfilePhoto.src.includes('default-profile.jpg')) {
                const mainPhotoClone = {
                    src: mainProfilePhoto.src,
                    alt: 'Profile Photo',
                    element: mainProfilePhoto
                };
                // We'll handle main photo separately in the click event
            }

            // Add click event to each gallery image
            galleryImages.forEach((img, index) => {
                img.addEventListener('click', function () {
                    openFullscreenViewer(index);
                });
            });

            // Add click event to main profile photo
            if (mainProfilePhoto) {
                mainProfilePhoto.addEventListener('click', function () {
                    // If there are gallery images, open from first image
                    // Otherwise, just open the main photo
                    if (galleryImages.length > 0) {
                        openFullscreenViewer(0);
                    } else {
                        // Create temporary array with just the main photo
                        const tempImages = [{
                            src: this.src,
                            alt: 'Profile Photo'
                        }];
                        openFullscreenViewer(0, tempImages);
                    }
                });
            }

            // Modal close functionality
            const modal = document.getElementById('fullscreenModal');
            const closeBtn = document.querySelector('.fullscreen-modal-close');
            const prevBtn = document.querySelector('.fullscreen-modal-prev');
            const nextBtn = document.querySelector('.fullscreen-modal-next');

            closeBtn.addEventListener('click', closeFullscreenViewer);

            prevBtn.addEventListener('click', function () {
                navigateImages(-1);
            });

            nextBtn.addEventListener('click', function () {
                navigateImages(1);
            });

            // Keyboard navigation
            document.addEventListener('keydown', function (e) {
                if (modal.style.display === 'block') {
                    if (e.key === 'Escape') closeFullscreenViewer();
                    if (e.key === 'ArrowLeft') navigateImages(-1);
                    if (e.key === 'ArrowRight') navigateImages(1);
                }
            });

            // Close modal when clicking outside image
            modal.addEventListener('click', function (e) {
                if (e.target === modal) {
                    closeFullscreenViewer();
                }
            });

            // Prevent modal close when clicking on image or navigation
            modal.querySelector('.fullscreen-modal-content').addEventListener('click', function (e) {
                e.stopPropagation();
            });

            prevBtn.addEventListener('click', function (e) {
                e.stopPropagation();
            });

            nextBtn.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        function openFullscreenViewer(index, customImages = null) {
            const imagesToUse = customImages || galleryImages;

            if (imagesToUse.length === 0) return;

            currentImageIndex = index;
            const modal = document.getElementById('fullscreenModal');
            const fullscreenImg = document.getElementById('fullscreenImage');
            const loadingDiv = document.getElementById('fullscreenLoading');
            const imageCounter = document.getElementById('imageCounter');
            const imageInfo = document.getElementById('imageInfo');
            const prevBtn = document.querySelector('.fullscreen-modal-prev');
            const nextBtn = document.querySelector('.fullscreen-modal-next');

            if (index >= 0 && index < imagesToUse.length) {
                const img = imagesToUse[index];

                // Show loading
                loadingDiv.style.display = 'block';
                fullscreenImg.style.display = 'none';

                // Set image source and handle loading
                fullscreenImg.onload = function () {
                    loadingDiv.style.display = 'none';
                    fullscreenImg.style.display = 'block';
                };

                fullscreenImg.onerror = function () {
                    loadingDiv.style.display = 'none';
                    fullscreenImg.style.display = 'block';
                    fullscreenImg.src = 'Images/default-profile.jpg';
                };

                fullscreenImg.src = img.src;
                fullscreenImg.alt = img.alt || 'Profile Photo';

                // Set image info
                imageInfo.textContent = img.alt || 'Profile Photo';

                // Set image counter
                imageCounter.textContent = `${index + 1} / ${imagesToUse.length}`;

                // Show/hide navigation buttons based on number of images
                if (imagesToUse.length <= 1) {
                    prevBtn.style.display = 'none';
                    nextBtn.style.display = 'none';
                } else {
                    prevBtn.style.display = 'flex';
                    nextBtn.style.display = 'flex';
                }

                // Show modal
                modal.style.display = 'block';
                document.body.style.overflow = 'hidden';

                // Preload adjacent images for smooth navigation
                preloadAdjacentImages(index, imagesToUse);
            }
        }

        function closeFullscreenViewer() {
            const modal = document.getElementById('fullscreenModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function navigateImages(direction) {
            const images = galleryImages.length > 0 ? galleryImages : [document.getElementById('<%= imgProfileLarge.ClientID %>')];
            let newIndex = currentImageIndex + direction;

            // Loop around if at ends
            if (newIndex < 0) {
                newIndex = images.length - 1;
            } else if (newIndex >= images.length) {
                newIndex = 0;
            }

            openFullscreenViewer(newIndex);
        }

        function preloadAdjacentImages(currentIndex, images) {
            if (!images || images.length <= 1) return;

            // Preload next image
            const nextIndex = (currentIndex + 1) % images.length;
            if (nextIndex !== currentIndex) {
                const nextImg = new Image();
                nextImg.src = images[nextIndex].src;
            }

            // Preload previous image
            const prevIndex = (currentIndex - 1 + images.length) % images.length;
            if (prevIndex !== currentIndex) {
                const prevImg = new Image();
                prevImg.src = images[prevIndex].src;
            }
        }

        // Image error handling
        document.addEventListener('DOMContentLoaded', function () {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.addEventListener('error', function () {
                    this.src = 'Images/default-profile.jpg';
                });
            });

            // Set random online status (for demo)
            const onlineStatus = document.getElementById('<%= onlineStatus.ClientID %>');
            const statusText = document.getElementById('<%= statusText.ClientID %>');
            const isOnline = Math.random() > 0.5;

            if (onlineStatus && statusText) {
                if (isOnline) {
                    onlineStatus.className = 'online-status marathi-font online';
                    statusText.textContent = 'Online Now';
                } else {
                    onlineStatus.className = 'online-status marathi-font offline';
                    statusText.textContent = 'Offline';
                }
            }

            // Initialize fullscreen image viewer
            initializeFullscreenViewer();

            // Get remaining counts on page load
            getRemainingCounts();
        });

        // Get remaining counts
        function getRemainingCounts() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) return;

            $.ajax({
                type: "POST",
                url: "ViewUserProfile.aspx/GetRemainingCounts",
                data: JSON.stringify({ userID: parseInt(currentUserID) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const counts = response.d.split(',');
                    const remainingMessages = counts[0];
                    const remainingInterests = counts[1];

                    console.log('Remaining - Messages:', remainingMessages, 'Interests:', remainingInterests);
                },
                error: function () {
                    console.log('Error getting remaining counts');
                }
            });
        }

        // Send Interest Function
        function sendInterest() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to send interest');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = document.getElementById('<%= btnSendInterest.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Interest sent successfully!', 'success');
                            
                            // Refresh remaining counts
                            setTimeout(getRemainingCounts, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = '#ffc107';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else if (response.d === "limit_exceeded") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('You have exceeded daily interest limit! Upgrade to premium.', 'error');
                            setTimeout(() => {
                                window.location.href = 'Membership.aspx';
                            }, 2000);
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        }

        // Send Message Function
        function sendMessage() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to send message');
                return;
            }

            const message = prompt('Enter your message (max 500 characters):', 'I like your profile. Please contact me.');
            if (message && message.length <= 500) {
                const button = document.getElementById('<%= btnSendMessage.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: parseInt(viewedUserID),
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Message sent successfully!', 'success');

                            // Refresh remaining counts
                            setTimeout(getRemainingCounts, 1000);
                        } else if (response.d === "limit_exceeded") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('You have exceeded daily message limit! Upgrade to premium.', 'error');
                            setTimeout(() => {
                                window.location.href = 'Membership.aspx';
                            }, 2000);
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            } else if (message) {
                alert('Message cannot exceed 500 characters');
            }
        }

        // Shortlist Profile Function
        function shortlistProfile() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            if (!currentUserID) {
                alert('Please login to shortlist profile');
                return;
            }

            const button = document.getElementById('<%= btnShortlist.ClientID %>');
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            $.ajax({
                type: "POST",
                url: "ViewUserProfile.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: parseInt(viewedUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, #dc3545, #c82333)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, #17a2b8, #138496)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            // Remove notification after 3 seconds
            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }
    </script>
</asp:Content>










--%>
