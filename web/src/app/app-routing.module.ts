import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { NotFoundComponent } from './pages/not-found/not-found.component';
import { PrivacyPolicyComponent } from './pages/privacy-policy/privacy-policy.component';
import { SupportComponent } from './pages/support/support.component';


const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'about', component: AboutComponent },
  { path: 'privacy-policy', component: PrivacyPolicyComponent },
  { path: 'support', component: SupportComponent },
  { path: 'not-found', component: NotFoundComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
