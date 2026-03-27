import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import Header from './Components/common/Header';
import Login from './Components/auth/login.jsx';
import Register from './Components/auth/register.jsx';
import Dashboard from './pages/Dashboard';
import CoachesPage from './pages/CoachesPage';
import BookSessionPage from './pages/BookSessionPage';
import MySessionsPage from './pages/MySessionsPage';
import WorkoutPlansPage from './pages/WorkoutPlansPage';
import DietPlansPage from './pages/DietPlansPage';
import ProgressPage from './pages/ProgressPage';
import RescheduleSessionPage from './pages/RescheduleSessionPage.jsx';
import NotificationsPage from './pages/NotificationPage.jsx';
import CoachSessionsPage from './pages/CoachSessionPage.jsx';
import MyClientsPage from './pages/MyClientsPage.jsx';
import CreateWorkoutPlanPage from './pages/CreateWorkoutPlan.jsx';
import ClientProgressPage from './pages/ClientProgressPage.jsx';
import MyReviewsPage from './pages/MyReviewsPage.jsx';
function ProtectedRoute({ children }) {
    const { user } = useAuth();
    return user ? children : <Navigate to="/login" />;
}

function PublicRoute({ children }) {
    const { user } = useAuth();
    return user ? <Navigate to="/dashboard" /> : children;
}

function AppLayout() {
    const { user } = useAuth();
    
    return (
        <>
            <Header />
            <div className="page-container">
                <Routes>
                    <Route path="/login" element={
                        <PublicRoute>
                            <Login />
                        </PublicRoute>
                    } />
                    <Route path="/register" element={
                        <PublicRoute>
                            <Register />
                        </PublicRoute>
                    } />
                    <Route path="/dashboard" element={
                        <ProtectedRoute>
                            <Dashboard />
                        </ProtectedRoute>
                    } />
                    <Route path="/coaches" element={
                        <ProtectedRoute>
                            <CoachesPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/book-session" element={
                        <ProtectedRoute>
                            <BookSessionPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/my-sessions" element={
                        <ProtectedRoute>
                            <MySessionsPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/workout-plans" element={
                        <ProtectedRoute>
                            <WorkoutPlansPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/diet-plans" element={
                        <ProtectedRoute>
                            <DietPlansPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/progress" element={
                        <ProtectedRoute>
                            <ProgressPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/" element={
                        <Navigate to="/dashboard" />
                    } />
                    <Route path="/reschedule-session" element={
                        <ProtectedRoute>
                            <RescheduleSessionPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/notifications" element={
                        <ProtectedRoute>
                            <NotificationsPage />
                        </ProtectedRoute>
                    } />

                    <Route path="/coach-sessions" element={
                        <ProtectedRoute>
                            <CoachSessionsPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/my-clients" element={
                        <ProtectedRoute>
                            <MyClientsPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/create-workout-plan" element={
                        <ProtectedRoute>
                            <CreateWorkoutPlanPage />
                        </ProtectedRoute>
                    } />
                    <Route path="/client-progress/:clientCode" element={
                        <ProtectedRoute>
                            <ClientProgressPage />
                        </ProtectedRoute>
                    } />

                    <Route path="/my-reviews" element={
                        <ProtectedRoute>
                            <MyReviewsPage />
                        </ProtectedRoute>
                    } />
                </Routes>
            </div>
        </>
    );
}

function App() {
    return (
        <AuthProvider>
            <Router>
                <AppLayout />
            </Router>
        </AuthProvider>
    );
}

export default App;