# -*- encoding : utf-8 -*-
class PatientsController < ApplicationController
  load_and_authorize_resource :except => :update_village_select
  def index
    @alfaorig = Array.new(26) {|i| (i+65).chr}
    @alfabeto = Array.new(26) {|i| (i+65).chr}
    @orden = Patient.find(:all, :order => 'nom, carte_code')
    @orden.collect!{|x| x.nom[0].chr.upcase if x.nom[0]}
    @alfabeto.collect!{|x|  (@orden.index(x).to_i/30)+1 if @orden.index(x)}
    @tipoorden = "nom"
    @patients = Patient.paginate :page => params[:page], :order => 'nom ASC, carte_code'
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient }
    end
  end
  
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  def create
    # @patient = Patient.new(params[:patient])
    respond_to do |format|
     if @patient.save
        format.html { redirect_to(@patient, :notice => 'Le patient a ete  cree.') }
        format.xml  { render :xml => @patient, :status => :created, :location => @patient }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to(@patient, :notice => 'Patient was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if @patient.destroy
      redirect_to(patients_url, :notice => "Successfully destroyed patient.")
    else
      redirect_to(patients_url, :alert => "Il n'est pas posible eliminer un patient sans eliminer ses consultations")
    end
  end
  
  def update_village_select
      authorize! :create, User
      villages = Village.where(:commune_id => params[:id]).order(:nom) unless params[:id].blank?
      render :partial => "villages", :locals => { :villages => villages }
  end
  
end
