import shutil
import skimage as ski
from time import time
from os.path import getsize
from os import remove
import os
import numpy as np
import warnings
warnings.filterwarnings("ignore")# im=ski.io.imread('1.jpg')
# im_l=ski.io.imread('1l.jpg')
# print(ski.measure.compare_ssim(im, im_l,multichannel=True))

class Simulated_Annealing():
	def __init__(self, target_image_path, P, r, T, sim_limit, var):
		target_image = ski.io.imread(target_image_path)
		self.target_image = target_image
		self.annealing_image = target_image
		self.P=P
		self.r=r
		self.T=T
		self.annealing_file_size=0
		self.best_file_size=getsize(target_image_path)
		self.best_file_id=-1
		self.image_count=0
		self.sim_limit=sim_limit
		self.var=var

	def anneal(self, time_limit):
		count=0
		start_time=time()
		filename='sim_0.9_Gaussian'
		if os.path.exists(filename):
			shutil.rmtree(filename)
		os.mkdir(filename)
		while(time()<start_time+time_limit):
			count+=1
			print('current temp count:', count)
			for step in range(self.P):
				print('  current step:', step)
				new_image, ind, success_time=self.get_next_image()
				ski.io.imsave(filename+'/'+str(ind)+'.jpg',new_image)
				new_file_size=getsize(filename+'/'+str(ind)+'.jpg')
				improvement=new_file_size-self.annealing_file_size
				if improvement>0:
					print('improvement')
					self.annealing_image=new_image
					self.annealing_file_size=new_file_size
					# ski.io.imsave(str(start_time)+'/'+str(ind)+'.png',new_image)
					if new_file_size>self.best_file_size:
						self.best_file_size=new_file_size
						self.best_file_id=ind
				else:
					if self.prob(improvement):
						self.annealing_image=new_image
						self.annealing_file_size=new_file_size
					else:
						remove(filename+'/'+str(ind)+'.jpg')
			self.T*=self.r
		print('best file:',self.best_file_id)

	def get_next_image(self):
		num_attempt=100
		new_image=self.add_noise(self.annealing_image)
		for i in range(num_attempt):
			print('      current attempt:',i)
			sim=ski.measure.compare_ssim(self.annealing_image, new_image, multichannel=True)
			if sim>self.sim_limit:
				self.image_count+=1
				return new_image, self.image_count, i+1
		return self.annealing_image, self.image_count, num_attempt

	def prob(self, delta):
		return np.random.uniform()<np.exp(delta/self.T)

	def add_noise(self, annealing_image):
		return annealing_image+np.random.normal(scale=self.var, size=annealing_image.shape)
		# return annealing_image+np.random.uniform(-self.var, self.var, size=annealing_image.shape)

if __name__=='__main__':
	# target_image, P, r, T, sim_limit, var
	SA=Simulated_Annealing('korean_fish.jpg', 10, 0.9, 10, -2, 100)
	SA.anneal(10000)